GitHistoryView = require '../lib/git-history-view'

describe "Git History View Test Suite", ->
    TEST_RESPONSE = "{\"author\": \"John Doe\",\"relativeDate\": \"2 Hours ago\",\"fullDate\": \"2014-09-08\",\"message\": \"Foo Bar with \"quotes\" and {stuff}\",\"hash\": \"12345\"},"

    it "should use 'message' as the filter key", ->
        view = new GitHistoryView()
        expect(view.getFilterKey()).toBe "message"

    it "should load selected revision", ->
        logItem = {hash: 12345}
        view = new GitHistoryView()

        passedItem = null
        callbackCalled = no
        view._loadRevision = (item) ->
            passedItem = item
            callbackCalled = yes

        view.confirmed(logItem)
        expect(passedItem).toEqual logItem.hash
        expect(callbackCalled).toBe yes

    it "should load selected revision with diff", ->
        logItem = {hash: 12345}
        view = new GitHistoryView()
        view._isDiffEnabled = ->
            return yes

        passedItem = null
        callbackCalled = no
        view._loadRevision = (item) ->
            passedItem = item
            callbackCalled = yes

        view.confirmed(logItem)
        expect(passedItem).toEqual logItem.hash
        expect(callbackCalled).toBe yes

    it "should load selected revision with diff", ->
        logItem = {hash: 12345}
        view = new GitHistoryView()
        view._isDiffEnabled = ->
            return yes

        passedItem = null
        callbackCalled = no
        view._loadRevision = (item) ->
            passedItem = item
            callbackCalled = yes

        view.confirmed(logItem)
        expect(passedItem).toEqual logItem.hash
        expect(callbackCalled).toBe yes

    it "should not load git history view upon failure", ->
        view = new GitHistoryView()
        error = no

        view.setError = ->
            error = yes

        view._fetchFileHistory = (stdout, exit) ->
            stdout ""
            exit 128

        view._loadLogData()
        expect(error).toBe yes

    it "should parse comma delimited objects in string to separate items", ->
        view = new GitHistoryView()
        logItems = null
        view._fetchFileHistory = (stdout, exit) ->
            stdout TEST_RESPONSE + TEST_RESPONSE
            exit 0
        view.setItems = (items) ->
            logItems = items

        view._loadLogData()
        expect(logItems.length).toBe 2
