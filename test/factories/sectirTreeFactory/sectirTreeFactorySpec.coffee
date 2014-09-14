describe 'sectirTreeFactory', ->
    sectirTreeFactory = undefined
    beforeEach(module('sectirTableModule'))

    beforeEach(inject( (_sectirTreeFactory_)->
        sectirTreeFactory = _sectirTreeFactory_
    ))

    it 'should has its "trees" property empty when constructed', ->
        expect(Object.keys(sectirTreeFactory.trees).length).toBe(0)

    it 'should reset its values when function reset is called', ->
        myTree =
            id: 3
        sectirTreeFactory.addTree myTree
        expect(sectirTreeFactory.getTreeHeight()).toBe(1)
        sectirTreeFactory.reset()
        expect(Object.keys(sectirTreeFactory.trees).length).toBe(0)

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
