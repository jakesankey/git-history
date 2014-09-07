path = require "path"
{BufferedProcess} = require "atom"

module.exports =
    configDefaults:
        gitPath: "/usr/bin/git"

    activate: (state) ->
        atom.workspaceView.command "git-history:show-file-history", => @toggle()

    toggle: ->
        stdout = (output) ->
            output = "[#{output.substring(0, output.length - 1)}]" if output
            console.log(output)

        exit = (code) -> console.log("git log exited with #{code}")

        inputFile = atom.workspace.getActiveEditor().getPath()

        jsonFormat = "{\"commit\": \"%h\",\"author\": \"%an <%ae>\",\"date\": \"%ad\",\"message\": \"%s\"},"

        new BufferedProcess {
          command: "/usr/bin/git",
          args: ["-C", path.dirname(inputFile), "log", "--show-notes", "--no-decorate", "--follow", "--pretty=format:#{jsonFormat}", inputFile],
          stdout,
          exit
        }
