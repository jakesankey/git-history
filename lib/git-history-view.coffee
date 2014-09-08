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
        stdout = (output) =>
            outputDir = "#{atom.getConfigDirPath()}/.git-history"
            fs.mkdir outputDir if not fs.existsSync outputDir
            outputFilePath = "#{outputDir}/#{logItem.hash}-#{path.basename(@file)}"
            fs.writeFile outputFilePath, output, (error) ->
                if not error
                    activePane = atom.workspace.getActivePane()
                    atom.workspace.open(outputFilePath, {split: 'right', activatePane: no}).done (newEditor) ->
                        activePane.activate()

        @_loadRevision logItem, stdout

    _loadRevision: (logItem, stdout) ->
        new BufferedProcess {
            command: "git",
            args: [
                "-C",
                path.dirname(@file),
                "show",
                "#{logItem.hash}:#{atom.project.getRepo().relativize(@file)}"
            ],
            stdout
        }


module.exports = GitHistoryView
