{WorkspaceView} = require 'atom'
GitHistory = require '../lib/git-history'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "GitHistory", ->
    activationPromise = null

    beforeEach ->
        atom.workspaceView = new WorkspaceView
        activationPromise = atom.packages.activatePackage('git-history')

    describe "when the git-history:toggle event is triggered", ->
        it "attaches and then detaches the view", ->
            expect(atom.workspaceView.find('.git-history')).not.toExist()

            # This is an activation event, triggering it will cause the package to be
            # activated.
            atom.workspaceView.trigger 'git-history:toggle'

            waitsForPromise ->
                activationPromise

            runs ->
                expect(atom.workspaceView.find('.git-history')).toExist()
                atom.workspaceView.trigger 'git-history:toggle'
                expect(atom.workspaceView.find('.git-history')).not.toExist()
