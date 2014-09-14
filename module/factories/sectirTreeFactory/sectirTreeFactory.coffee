angular.module 'sectirTableModule.treeFactory', []
    .factory 'sectirTreeFactory', ->
        new class SectirTreeFactory
            constructor: ->
                @trees = {}
            reset: ->
                @trees = {}
            addTree: (tree, namespace="default") ->
                treeM = new TreeModel
                @trees[namespace] = treeM.parse tree
                return
            getTreeHeight: (namespace="default") ->
                retVal = 0
                @trees[namespace].walk (node) ->
                    level = node.getPath().length
                    if level > retVal
                        retVal = level
                    return
                retVal
            getNodeHeightById: (id, namespace="default") ->
                id = String id
                retVal = false
                @trees[namespace].walk (node) ->
                    modelId = String node.model.id
                    if modelId is id
                        retVal = node.getPath().length
                        return false
                retVal
            hasChildren: (node) ->
                node.children? and node.children.length > 0
            getLeafs: (namespace="default") ->
                strategy =
                    strategy: 'breadth'
                self = @
                retVal = @trees[namespace].all strategy, (node) ->
                    not self.hasChildren node
                retVal
