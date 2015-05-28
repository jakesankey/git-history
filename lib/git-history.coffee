GitHistoryView = require "./git-history-view"

class GitHistory

    config:
        showDiff:
            type: "boolean"
            default: yes
        maxCommits:
            type: "integer"
            default: 100

    activate: ->
        atom.commands.add "atom-text-editor",
            "git-history:show-file-history": @_loadGitHistoryView

    _loadGitHistoryView: ->
        new GitHistoryView(atom.workspace.getActiveTextEditor()?.getPath())

module.exports = new GitHistory()
