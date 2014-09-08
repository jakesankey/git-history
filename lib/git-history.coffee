path = require "path"
{BufferedProcess} = require "atom"
GitHistoryView = require "./git-history-view"

class GitHistory
    configDefaults:
        maxCommits: 100,
        cursorShouldBeInHistoryPane: yes

    activate: (state) ->
        atom.workspaceView.command "git-history:show-file-history", => @_showFileHistory()

    _showFileHistory: ->
        inputFile = @_getCurrentFile()
        log = []

        stdout = (output) ->
            output = output.replace("\n", "").trim()
            if output?.substring(output.length - 1) is ","
                output = output.substring(0, output.length - 1)

            log.push item for item in JSON.parse "[#{output}]"

        exit = (code) =>
            @_loadGitHistoryView(log, inputFile) if code is 0

        @_fetchFileHistory(inputFile, stdout, exit)

    _fetchFileHistory: (file, stdout, exit) ->
        format = "{\"hash\": \"%h\",\"author\": \"%an\",\"relativeDate\": \"%cr\",\"fullDate\": \"%ad\",\"message\": \"%s\"},"

        new BufferedProcess {
            command: "git",
            args: [
                "-C",
                path.dirname(file),
                "log",
                "--max-count=#{@_getMaxNumberOfCommits()}",
                "--follow",
                "--pretty=format:#{format}",
                "--topo-order",
                "--date=short",
                file
            ],
            stdout,
            exit
        }

    _getMaxNumberOfCommits: ->
        return atom.config.get("git-history.maxCommits")

    _getCurrentFile: ->
        atom.workspace.getActiveEditor()?.getPath()

    _loadGitHistoryView: (logItems, file) ->
        new GitHistoryView(logItems, file)


module.exports = new GitHistory()
