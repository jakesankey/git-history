GitHistoryView = require "./git-history-view"

class GitHistory

    configDefaults:
        maxCommits: 100,
        cursorShouldBeInHistoryPane: yes

    activate: ->
        atom.workspaceView.command "git-history:show-file-history", => @_loadGitHistoryView()

    _loadGitHistoryView: ->
        new GitHistoryView(atom.workspace.getActiveEditor()?.getPath())


module.exports = new GitHistory()
