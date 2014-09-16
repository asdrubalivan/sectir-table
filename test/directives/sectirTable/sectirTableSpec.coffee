xdescribe 'sectirTable', ->
    @$scope = undefined
    @$compile = undefined

    beforeEach(module('sectirTableModule'))

    beforeEach(inject(($compile, $rootScope) ->
        @$scope = $rootScope
        @$compile = $compile
    ))

    it 'should contain 1 header row when only one element is provided', ->
        @$scope.tabledata =
            name: "Header"
        elm = angular.element '''
            <sectir-table tabledata="tabledata">
            </sectir-table>
        '''
        linkFn = @$compile elm
        linkFn @$scope
        elements = elm.find 'tr.sectir-table-header th'
        expect(elements.length).toBe(1)
