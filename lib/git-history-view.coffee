{SelectListView, BufferedProcess} = require 'atom'

class GitHistoryView extends SelectListView
    # @content: ->
    #     @div class: 'git-history overlay from-top', =>
    #         @div "The GitHistory package is Alive! It's ALIVE!", class: "message"

    initialize: (@data) ->
        super
        atom.workspaceView.append this
        # atom.workspaceView.command "git-history:show-file-history", => @toggle()

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


# Os = require 'os'
# Path = require 'path'
# fs = require 'fs-plus'
#
# {$$, BufferedProcess, SelectListView} = require 'atom'
#
# GitShow = require '../models/git-show'
#
# module.exports =
# class LogListView extends SelectListView
#
#   currentFile = ->
#     atom.project.relativize atom.workspace.getActiveEditor()?.getPath()
#
#   showCommitFilePath = ->
#     Path.join Os.tmpDir(), "atom_git_plus_commit.diff"
#
#   initialize: (@data, @onlyCurrentFile) ->
#     super
#     @addClass 'overlay from-top'
#     @parseData()
#
#   parseData: ->
#     @data = @data.split("\n")[...-1]
#     @setItems(
#       for item in @data when item != ''
#         tmp = item.match /([\w\d]{7});\|(.*);\|(.*);\|(.*)/
#         {hash: tmp?[1], author: tmp?[2], title: tmp?[3], time: tmp?[4]}
#     )
#     atom.workspaceView.append this
#     @focusFilterEditor()
#
#   getFilterKey: -> 'title'
#
#   viewForItem: (commit) ->
#     $$ ->
#       @li =>
#         @div class: 'text-highlight text-huge', commit.title
#         @div class: '', "#{commit.hash} by #{commit.author}"
#         @div class: 'text-info', commit.time
#
#   confirmed: ({hash}) ->
#     GitShow(hash, currentFile() if @onlyCurrentFile)
