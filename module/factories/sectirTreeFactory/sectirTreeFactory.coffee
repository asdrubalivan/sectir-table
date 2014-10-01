angular.module 'sectirTableModule.treeFactory', []
    .factory 'sectirTreeFactory', ->
        new class SectirTreeFactory
            constructor: ->
                @trees = {}
                @maxHeights = {}
                @nodesById = {}
            reset: ->
                @trees = {}
                @maxHeights = {}
                @nodesById = {}
            addTree: (tree, namespace="default") ->
                treeM = new TreeModel
                @trees[namespace] = treeM.parse tree
                @maxHeights[namespace] = undefined
                @nodesById[namespace] = {}
                return
            getTreeHeight: (namespace="default") ->
                if @maxHeights[namespace]?
                    return @maxHeights[namespace]
                retVal = 0
                @trees[namespace].walk (node) ->
                    level = node.getPath().length
                    if level > retVal
                        retVal = level
                    return
                @maxHeights[namespace] = retVal
            getNodeHeightById: (id, namespace="default") ->
                val = @getNodeById id, namespace
                if val
                    val.getPath().length
                else
                    false
            getNodeById: (id, namespace="default") ->
                if not @trees[namespace]?
                    return false
                if @nodesById[namespace][id]?
                    return @nodesById[namespace][id]
                id = String id
                retVal = false
                @trees[namespace]?.walk (node) ->
                    modelId = String node.model.id
                    if modelId is id
                        retVal = node
                        return false
                @nodesById[namespace][id] = retVal
            hasChildren: (node) ->
                node.children? and node.children.length > 0
            hasChildrenById: (id, namespace="default") ->
                @hasChildren(@getNodeById(id,namespace))
            getLeafs: (namespace="default", st = "breadth") ->
                strategy =
                    strategy: st
                self = @
                retVal =
                    if @trees[namespace]?
                        @trees[namespace].all strategy, (node) ->
                            not self.hasChildren node
                    else
                        false
                retVal
            getRows: (namespace="default") ->
                strategy =
                    strategy: 'breadth'
                retVal = []
                curLevel = -1 #Empezamos con -1 ya que el nivel menor es 0
                self = @
                @trees[namespace].walk strategy, (node) ->
                    nodeHeight =
                        self.getNodeHeightById node.model.id, namespace
                    if nodeHeight isnt curLevel #Nivel ha cambiado
                        retVal.push []
                        curLevel = nodeHeight
                    retVal[curLevel - 1].push node
                    return
                retVal
            getNodeLevelsFromMax: (id, namespace="default") ->
                node = @getNodeById id, namespace
                return false if node is false
                @getTreeHeight(namespace) - node.getPath().length
            getNumberLeafsFromNode: (id, namespace="default") ->
                node = @getNodeById id, namespace
                return false if node is false
                retVal = 0
                self = @
                node.walk (aNode) ->
                    if not self.hasChildren aNode
                        retVal++
                    return
                retVal
