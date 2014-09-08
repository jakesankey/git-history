{WorkspaceView} = require "atom"
GitHistoryView = require '../lib/git-history-view'

describe "Git History View Test Suite", ->
    beforeEach ->
        atom.workspaceView = new WorkspaceView()

    it "should use 'message' as the filter key", ->
        view = new GitHistoryView({}, "path")
        expect(view.getFilterKey()).toBe "message"

    it "should load selected revision", ->
        logItem = {hash: 12345}
        view = new GitHistoryView(logItem, "path")

        passedItem = null
        callbackCalled = no
        view._loadRevision = (item) ->
            passedItem = item
            callbackCalled = yes

        view.confirmed(logItem)
        expect(passedItem).toEqual logItem
        expect(callbackCalled).toBe yes
