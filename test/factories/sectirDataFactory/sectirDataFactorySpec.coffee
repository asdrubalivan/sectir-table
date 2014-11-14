describe 'sectirTreeFactory', ->
    sectirDataFactory = undefined
    beforeEach(module('sectirTableModule'))

    beforeEach(inject( (_sectirDataFactory_)->
        sectirDataFactory = _sectirDataFactory_
    ))
   
    it 'should save data correctly', ->
        sectirDataFactory.saveData ["myData1", "myData2"]
        sectirDataFactory.saveData ["myDataNamespaced"], "namespace2"
        expect(sectirDataFactory.getData()).toEqual ["myData1", "myData2"]
        expect(sectirDataFactory.getData("namespace2")).toEqual(
            ["myDataNamespaced"]
        )
