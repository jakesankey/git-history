{View, BufferedProcess} = require 'atom'

class GitHistoryView extends View
    @content: ->
        @div class: 'git-history overlay from-top', =>
            @div "The GitHistory package is Alive! It's ALIVE!", class: "message"

    initialize: (serializeState) ->
        atom.workspaceView.command "git-history:show-file-history", => @toggle()

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @detach()

    toggle: ->
        console.log "GitHistoryView was toggled!"
        if @hasParent()
            @detach()
        else
            atom.workspaceView.append(this)

module.exports = GitHistoryView
