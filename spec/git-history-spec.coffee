{WorkspaceView} = require "atom"
gitHistory = require "../lib/git-history"

describe "Git History Test Suite", ->

    beforeEach ->
        atom.workspaceView = new WorkspaceView()

    it "should load git history view upon upon event trigger", ->
        called = no
        gitHistory._loadGitHistoryView = ->
            called = yes

        gitHistory.activate()
        atom.workspaceView.trigger("git-history:show-file-history")
        expect(called).toBe yes
