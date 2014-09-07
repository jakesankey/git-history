GitHistoryView = require './git-history-view'

module.exports =
    gitHistoryView: null

    activate: (state) ->
        @gitHistoryView = new GitHistoryView(state.gitHistoryViewState)

    deactivate: ->
        @gitHistoryView.destroy()

    serialize: ->
        gitHistoryViewState: @gitHistoryView.serialize()
