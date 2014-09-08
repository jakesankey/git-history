gitHistory = require '../lib/git-history'

describe "Git History Test Suite", ->
    TEST_PATH = "/path/file.coffee"
    TEST_RESPONSE = "{\"hash\": \"12345\", \"author\": \"John Doe\", \"relativeDate\": \"2 Hours ago\", \"fullDate\": \"2014-09-08\", \"message\": \"Foo Bar\"}"

    beforeEach ->
        gitHistory._getMaxNumberOfCommits = -> 100
        gitHistory._getCurrentFile = -> TEST_PATH
        gitHistory._fetchFileHistory = (file, stdout, exit) ->
            stdout TEST_RESPONSE
            exit 0

    it "should load git history view upon success", ->
        logItems = null
        inputFile = null
        gitHistory._loadGitHistoryView = (items, file) ->
            logItems = items
            inputFile = file

        gitHistory._showFileHistory()
        expect(logItems.length).toEqual(1)
        expect(inputFile).toEqual(TEST_PATH)

    it "should not load git history view upon failure", ->
        logItems = null
        inputFile = null
        gitHistory._fetchFileHistory = (file, stdout, exit) ->
            stdout ""
            exit 128
        gitHistory._loadGitHistoryView = (items, file) ->
            logItems = items
            inputFile = file

        gitHistory._showFileHistory()
        expect(logItems).toEqual(null)
        expect(inputFile).toEqual(null)
