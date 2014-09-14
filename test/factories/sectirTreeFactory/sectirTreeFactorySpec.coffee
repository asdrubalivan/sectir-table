describe 'sectirTreeFactory', ->
    sectirTreeFactory = undefined
    beforeEach(module('sectirTableModule'))

    beforeEach(inject( (_sectirTreeFactory_)->
        sectirTreeFactory = _sectirTreeFactory_
    ))

    it 'should has its "trees" property empty when constructed', ->
        expect(Object.keys(sectirTreeFactory.trees).length).toBe(0)
