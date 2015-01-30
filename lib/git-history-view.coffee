path = require "path"
fs = require "fs"
{$$} = require "atom-space-pen-views"
{SelectListView, BufferedProcess} = require "atom"

class GitHistoryView extends SelectListView

    initialize: (@file) ->
        super
        @_setup() if file

    _setup: ->
        @setLoading "Loading history for #{path.basename(@file)}"
        @addClass "overlay from-top"
        atom.workspaceView.append this
        @focusFilterEditor()
        @_loadLogData()

    _loadLogData: ->
        logItems = []

        stdout = (output) ->
            output = output.replace("\n", "").trim()
            if output?.substring(output.length - 1) is ","
                output = output.substring(0, output.length - 1)

            logItems.push item for item in JSON.parse "[#{output}]"

        exit = (code) =>
            if code is 0 and logItems.length isnt 0
                @setItems logItems
            else
                @setError "No history found for #{path.basename(@file)}"


        @_fetchFileHistory(stdout, exit)

    _fetchFileHistory: (stdout, exit) ->
        format = "{\"hash\": \"%h\",\"author\": \"%an\",\"relativeDate\": \"%cr\",\"fullDate\": \"%ad\",\"message\": \"%f\"},"

        new BufferedProcess {
            command: "git",
            args: [
                "-C",
                path.dirname(@file),
                "log",
                "--max-count=#{@_getMaxNumberOfCommits()}",
                "--pretty=format:#{format}",
                "--topo-order",
                "--date=short",
                @file
            ],
            stdout,
            exit
        }

    _getMaxNumberOfCommits: ->
        return atom.config.get("git-history.maxCommits")

    _isDiffEnabled: ->
        return atom.config.get("git-history.diffWithHead")

    getFilterKey: -> "message"

    viewForItem: (logItem) ->
        fileName = path.basename(@file)
        $$ ->
            @li =>
                @div class: "text-highlight text-huge", logItem.message
                @div "#{logItem.author} - #{logItem.relativeDate} (#{logItem.fullDate})"
                @div class: "text-info", "#{logItem.hash} - #{fileName}"

    confirmed: (logItem) ->
        fileContents = ""
        stdout = (output) =>
            fileContents += output

        exit = (code) =>
            if code is 0
                outputDir = "#{atom.getConfigDirPath()}/.git-history"
                fs.mkdir outputDir if not fs.existsSync outputDir
                outputFilePath = "#{outputDir}/#{logItem.hash}-#{path.basename(@file)}"
                fs.writeFile outputFilePath, fileContents, (error) ->
                    if not error
                        options = {split: "right", activatePane: yes}
                        atom.workspace.open(outputFilePath, options)
            else
                @setError "Could not retrieve history for #{path.basename(@file)}"

        @_loadRevision logItem.hash, stdout, exit

    _loadRevision: (hash, stdout, exit) ->
        showDiff = @_isDiffEnabled()
        diffArgs = [
            "-C",
            path.dirname(@file),
            "diff",
            "-U9999999",
            "HEAD:#{atom.project.getRepo()?.relativize(@file)}",
            "#{hash}:#{atom.project.getRepo()?.relativize(@file)}"
        ]
        showArgs = [
            "-C",
            path.dirname(@file),
            "show",
            "#{hash}:#{atom.project.getRepo().relativize(@file)}"
        ]
        new BufferedProcess {
            command: "git",
            args: if showDiff then diffArgs else showArgs,
            stdout,
            exit
        }

module.exports = GitHistoryView
