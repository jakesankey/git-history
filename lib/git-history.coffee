path = require "path"
{BufferedProcess} = require "atom"
GitHistoryView = require "./git-history-view"

module.exports =
    # configDefaults:
    #     gitPath: "/usr/bin/git"

    activate: (state) ->
        atom.workspaceView.command "git-history:show-file-history", => @showFileHistory()

    showFileHistory: ->

        log = []
        stdout = (output) ->
            output = output.replace("\n", "").trim()
            if output?.substring(output.length - 1) is ","
                output = output.substring(0, output.length - 1)

            log.push item for item in JSON.parse "[#{output}]"

        exit = (code) ->
            if code is 0
                new GitHistoryView(log)
            # console.log(log)

        inputFile = atom.workspace.getActiveEditor().getPath()

        format = "{\"commit\": \"%h\",\"author\": \"%an <%ae>\",\"date\": \"%ad\",\"message\": \"%s\"},"

        new BufferedProcess {
          command: "git", #atom.config.get("git-history.gitPath"),
          args: ["-C", path.dirname(inputFile), "log", "--follow", "--pretty=format:#{format}", "--topo-order", '--date=short', inputFile],
          stdout,
          exit
        }
