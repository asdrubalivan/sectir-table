describe 'sectirTreeFactory', ->
    sectirTreeFactory = undefined
    beforeEach(module('sectirTableModule'))

    beforeEach(inject( (_sectirTreeFactory_)->
        sectirTreeFactory = _sectirTreeFactory_
    ))
    
    #Helper function
    leafsIds = (nodes) ->
        (val.model.id for val in nodes)


    it 'should has its properties empty when constructed', ->
        expect(Object.keys(sectirTreeFactory.trees).length).toBe(0)
        expect(Object.keys(sectirTreeFactory.maxHeights).length).toBe(0)
    it 'should reset its values when function reset is called', ->
        myTree =
            id: 3
        sectirTreeFactory.addTree myTree
        expect(sectirTreeFactory.getTreeHeight()).toBe(1)
        sectirTreeFactory.reset()
        expect(Object.keys(sectirTreeFactory.trees).length).toBe(0)
        expect(Object.keys(sectirTreeFactory.maxHeights).length).toBe(0)

    it 'should get the correct height of a "tree property"', ->
        treeVar1 =
            {
                id: 1
                name: "Header"
                children:
                    [
                        {
                            id: 2
                            name: "Header 2"
                        }
                    ]
            }
        sectirTreeFactory.addTree treeVar1
        expect(sectirTreeFactory.getTreeHeight()).toBe(2)
        
        treeVar2 =
            {
                id: 1
                name: "Header"
                children:
                    [
                        {
                            id: 2
                            name: "Header 2"
                        }
                        {
                            id: 3
                            name: "Header 3"
                            children:
                                [
                                    id: 4
                                ]
                        }
                    ]
            }
        sectirTreeFactory.addTree treeVar2, "namespace2"
        expect(sectirTreeFactory.getTreeHeight("namespace2")).toBe(3)
        
        #Testeamos treeVar2 en el namespace de treeVar1
        #para evitar error de cacheo
        sectirTreeFactory.addTree treeVar2
        expect(sectirTreeFactory.getTreeHeight()).toBe(3)

    it 'should get the correct node height by id', ->
        treeVar =
        {
            id: 1
            name: "Header"
            children:
                [
                    {
                        id: 2
                        name: "Header 2"
                    }
                    {
                        id: 3
                        name: "Header 3"
                        children:
                            [
                                id: 4
                            ]
                    }
                ]
        }
        sectirTreeFactory.addTree treeVar
        expect(sectirTreeFactory.getNodeHeightById(2)).toBe(2)
        expect(sectirTreeFactory.getNodeHeightById("2")).toBe(2)
        expect(sectirTreeFactory.getNodeHeightById(4)).toBe(3)
        expect(sectirTreeFactory.getNodeHeightById("otherName")).toBe(false)
        expect(sectirTreeFactory.getNodeHeightById(1)).toBe(1)
 
        sectirTreeFactory.addTree treeVar, "other"
        expect(sectirTreeFactory.getNodeHeightById(2, "other")).toBe(2)
        expect(sectirTreeFactory.getNodeHeightById("2", "other")).toBe(2)
        expect(sectirTreeFactory.getNodeHeightById(4, "other")).toBe(3)
        expect(sectirTreeFactory.getNodeHeightById("otherName",
            "other")).toBe(false)
        expect(sectirTreeFactory.getNodeHeightById(1, "other")).toBe(1)



    it 'should have a function to know if a node has children', ->
        treeWithoutChildren =
            {
                id: 1
            }
        treeWithChildren =
            {
                id: 2
                children:
                    [
                        {
                            id: 3
                        }
                        {
                            id: 4
                        }
                    ]
            }
        treeWithEmptyChildren =
            {
                id: 3
                children:
                    []
            }
        treeM = new TreeModel
        node = treeM.parse treeWithoutChildren
        expect(sectirTreeFactory.hasChildren(node)).toBe(false)
        node = treeM.parse treeWithChildren
        expect(sectirTreeFactory.hasChildren(node)).toBe(true)
        node = treeM.parse treeWithEmptyChildren
        expect(sectirTreeFactory.hasChildren(node)).toBe(false)

    it 'should get leaf of a tree correctly', ->
        testLeaf = (obj, equalTo) ->
            sectirTreeFactory.addTree obj
            nodes = sectirTreeFactory.getLeafs()
            idNodes = leafsIds nodes
            expect(idNodes).toEqual(equalTo)
        treeWithoutChildren =
            {
                id: 1
            }
        treeWithTwoRows =
            {
                id: 1
                children:
                    [
                        {
                            id: 2
                        }
                        {
                            id: 3
                        }
                    ]
            }
        treeWithThreeRows =
            {
                id: 1
                children:
                    [
                        {
                            id: 2
                        }
                        {
                            id: 3
                            children:
                                [
                                    {
                                        id: 4
                                    }
                                    {
                                        id: 5
                                    }
                                    {
                                        id: 6
                                    }
                                ]
                        }
                    ]
            }
        testLeaf treeWithoutChildren, [1]
        testLeaf treeWithTwoRows, [2, 3]
        testLeaf treeWithThreeRows, [2, 4, 5, 6]
        expect(sectirTreeFactory.getLeafs("non-existent")).toBe(false)
    
    it 'should return all rows of a tree', ->
        testRows = (obj, equalTo) ->
            sectirTreeFactory.addTree obj
            nodes = sectirTreeFactory.getRows()
            idNodes = (leafsIds node for node in nodes)
            expect(idNodes).toEqual(equalTo)
        treeWithOneRow =
            id: 4
        treeWithTwoRows =
            id: 5
            children:
                [
                    {
                        id: 6
                    }
                    {
                        id: 7
                    }
                    {
                        id: 8
                    }
                ]
        treeWithThreeRows =
            id: 10
            children:
                [
                    {
                        id: 11
                    }
                    {
                        id: 12
                        children:
                            [
                                {
                                    id: 13
                                }
                                {
                                    id: 14
                                }
                            ]
                    }
                    {
                        id: 15
                    }
                    {
                        id: 16
                        children:
                            [
                                {
                                    id: 17
                                }
                                {
                                    id: 18
                                }
                                {
                                    id: 19
                                }
                            ]
                    }
                ]
        testRows treeWithOneRow, [[4]]
        testRows treeWithTwoRows, [[5], [6, 7, 8]]
        testRows treeWithThreeRows, [
            [10]
            [11, 12, 15, 16]
            [13, 14, 17, 18, 19]
        ]
    
    it 'should return a correct node level', ->
        treeVar1 =
            id: 2
            children:
                [
                    {
                        id: 3
                    }
                    {
                        id: 4
                    }
                    {
                        id: 5
                        children:
                            [
                                {
                                    id: 6
                                }
                            ]
                    }
                ]
        sectirTreeFactory.addTree treeVar1
        expect(sectirTreeFactory.getNodeLevelsFromMax(3)).toBe(1)
        expect(sectirTreeFactory.getNodeLevelsFromMax(2)).toBe(2)
        expect(sectirTreeFactory.getNodeLevelsFromMax(4)).toBe(1)
        expect(sectirTreeFactory.getNodeLevelsFromMax(5)).toBe(1)
        expect(sectirTreeFactory.getNodeLevelsFromMax(6)).toBe(0)
        expect(sectirTreeFactory.getNodeLevelsFromMax(6,"other")).toBe(false)
        expect(sectirTreeFactory.getNodeLevelsFromMax(null)).toBe(false)
        expect(sectirTreeFactory.getNodeLevelsFromMax("other")).toBe(false)


    it 'should return correct number of leafs', ->
        tree =
            id: 1
            children:
                [
                    {
                        id: 2
                        children:
                            [
                                {
                                    id: 3
                                }
                                {
                                    id: 4
                                    children:
                                        [
                                            {
                                                id: 5
                                            }
                                        ]
                                }
                                {
                                    id: 6
                                }
                                {
                                    id: 7
                                }
                                {
                                    id: 8
                                    children:
                                        [
                                            {
                                                id: 9
                                            }
                                            {
                                                id: 10
                                            }
                                        ]
                                }
                            ]
                    }
                ]
        sectirTreeFactory.addTree tree
        expect(sectirTreeFactory.getNumberLeafsFromNode(1)).toBe(6)
        expect(sectirTreeFactory.getNumberLeafsFromNode(2)).toBe(6)
        expect(sectirTreeFactory.getNumberLeafsFromNode(3)).toBe(1)
        expect(sectirTreeFactory.getNumberLeafsFromNode(4)).toBe(1)
        expect(sectirTreeFactory.getNumberLeafsFromNode(5)).toBe(1)
        expect(sectirTreeFactory.getNumberLeafsFromNode(6)).toBe(1)
        expect(sectirTreeFactory.getNumberLeafsFromNode(7)).toBe(1)
        expect(sectirTreeFactory.getNumberLeafsFromNode(8)).toBe(2)
        expect(sectirTreeFactory.getNumberLeafsFromNode(9)).toBe(1)
        expect(sectirTreeFactory.getNumberLeafsFromNode(10)).toBe(1)
        expect(sectirTreeFactory.getNumberLeafsFromNode(11)).toBe(false)
        expect(sectirTreeFactory.getNumberLeafsFromNode(10, "other"))
            .toBe(false)
        
