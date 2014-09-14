angular.module 'sectirTableModule.treeFactory', []
    .factory 'sectirTreeFactory', ->
        new class SectirTreeFactory
            constructor: ->
                @trees = {}
            addTree: (tree, namespace="default") ->
                treeM = new TreeModel
                @trees[namespace] = treeM.parse tree
                return
            
