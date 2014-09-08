path = require "path"
{BufferedProcess} = require "atom"
GitHistoryView = require "./git-history-view"

module.exports =

    configDefaults:
        maxCommits: 100

    activate: (state) ->
        atom.workspaceView.command "git-history:show-file-history", => @showFileHistory()

    showFileHistory: ->
        inputFile = atom.workspace.getActiveEditor().getPath()

        log = []

        stdout = (output) ->
            output = output.replace("\n", "").trim()
            if output?.substring(output.length - 1) is ","
                output = output.substring(0, output.length - 1)

            log.push item for item in JSON.parse "[#{output}]"

        exit = (code) ->
            new GitHistoryView(log, inputFile) if code is 0

        format = "{\"hash\": \"%h\",\"author\": \"%an <%ae>\",\"relativeDate\": \"%cr\",\"fullDate\": \"%ad\",\"message\": \"%s\"},"

        new BufferedProcess {
            command: "git",
            args: [
                "-C",
                path.dirname(inputFile),
                "log",
                "--max-count=#{atom.config.get("git-history.maxCommits")}",
                "--follow",
                "--pretty=format:#{format}",
                "--topo-order",
                "--date=short",
                inputFile
            ],
            stdout,
            exit
        }
