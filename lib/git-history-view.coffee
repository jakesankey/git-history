path = require "path"
fs = require "fs"
{SelectListView, BufferedProcess} = require "atom"

class GitHistoryView extends SelectListView

    initialize: (@data, @file) ->
        super
        @setItems data
        @addClass "overlay from-top"
        atom.workspaceView.append this
        @focusFilterEditor()

    getFilterKey: -> "message"

    viewForItem: (logItem) ->
        """<li>
            <div class='text-highlight text-huge'>#{logItem.message}</div>
            <div>#{path.basename(@file)} - #{logItem.relativeDate}</div>
            <div class='text-info'>#{logItem.hash} committed on #{logItem.fullDate}</div>
           </li>"""

    confirmed: (logItem) ->
        fileContents = ""
        stdout = (output) =>
            fileContents += output

        exit = (code) =>
            activateHistoryPane = atom.config.get("git-history.cursorShouldBeInHistoryPane")
            if code is 0
                outputDir = "#{atom.getConfigDirPath()}/.git-history"
                fs.mkdir outputDir if not fs.existsSync outputDir
                outputFilePath = "#{outputDir}/#{logItem.hash}-#{path.basename(@file)}"
                fs.writeFile outputFilePath, fileContents, (error) ->
                    if not error
                        originalPane = atom.workspace.getActivePane()
                        options = {split: "right", activatePane: activateHistoryPane}
                        atom.workspace.open(outputFilePath, options).done ->
                            originalPane.activate() if not activateHistoryPane

        @_loadRevision logItem, stdout, exit

    _loadRevision: (logItem, stdout, exit) ->
        new BufferedProcess {
            command: "git",
            args: [
                "-C",
                path.dirname(@file),
                "show",
                "#{logItem.hash}:#{atom.project.getRepo().relativize(@file)}"
            ],
            stdout,
            exit
        }


module.exports = GitHistoryView
