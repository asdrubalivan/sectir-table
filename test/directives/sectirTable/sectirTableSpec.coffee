describe 'sectirTable', ->
    @$scope = undefined
    @$compile = undefined

    beforeEach(module('sectirTableModule'))

    beforeEach(inject(($compile, $rootScope) ->
        @$scope = $rootScope
        @$compile = $compile
    ))
    it 'should contain 1 row when table data has only one row', ->
        @$scope.tabledata =
            id: 1
            name: "Header"
        @$scope.name = "default"
        elm = angular.element '''
            <sectir-table tabledata="tabledata" namespace="name">
            </sectir-table>
        '''
        linkFn = @$compile elm
        elm = linkFn @$scope
        elements = elm.find("tr")
        lenTr = 0
        angular.forEach elements, (value) ->
            el = angular.element value
            if el.hasClass 'sectir-table-header'
                lenTr++
        expect(lenTr).toBe(1)
    
    it 'should create a table when a correct input is provided', ->
        @$scope.tabledata =
            id: 2
            name: "Name"
            children:
                [
                    {
                        id: 3
                        name: "Name 2"
                    }
                ]
        table = angular.element '''
            <sectir-table tabledata="tabledata">
            </sectir-table>
        '''
        table = @$compile(table)(@$scope)
        expect(angular.isElement(table.find("table"))).toBe(true)
    it 'should contain as many rows as the height of a tree', ->
        tree1 =
            id: 1
            name: "myName"
            children:
                [
                    {
                        id: 2
                        name: "myNam2"
                    }
                    {
                        id: 3
                        name: "myName3"
                    }
                ]
        tree2 =
            id: 1
            name: "myName"
            children:
                [
                    {
                        id: 2
                        name: "myName2"
                    }
                    {
                        id: 3
                        name: "myName3"
                        children:
                            [
                                {
                                    id: 4
                                    name: "myName4"
                                }
                                {
                                    id: 5
                                    name: "myName5"
                                }
                            ]
                    }
                ]
        tree3 =
                name: "Header"
                id: 1
                children:
                    [
                        {
                            id: 2
                            name: "Header 2-1"
                            children:
                                [
                                    {
                                        id: 3
                                        name: "Header 3-1"
                                    }
                                    {
                                        id: 4
                                        name: "Header no se que mas"
                                    }
                                ]
                        }
                        {
                            id: 5
                            name: "Header 2-2"
                            children:
                                [
                                    {
                                        id: 6
                                        name: "Header 3-2"
                                    }
                                    {
                                        id: 7
                                        name: "Header 4-2"
                                    }
                                    {
                                        id: 8
                                        name: "Header 5-2"
                                        children:
                                            [
                                                name: "Jorge"
                                            ]
                                    }
                                ]
                        }
                        {
                            id: 9
                            name: "Header 2-3"
                            children:
                                [
                                    {
                                        id: 10
                                        name: "Header 3-5"
                                        children:
                                            [
                                                {
                                                    id: 11
                                                    name: "Bla"
                                                    children:
                                                        [
                                                            id: 12
                                                            name: "Otro bla bla"
                                                           ,
                                                            id: 13
                                                            name: "Y otro más"
                                                        ]
                                                }
                                            ]
                                    }
                                ]
                        }
                    ]
        self = @
        compile = (data, name) ->
            self.$scope.tabledata = data
            self.$scope.name = name
            elm = angular.element '''
                <sectir-table tabledata="tabledata" namespace="name">
                </sectir-table>
            '''
            linkFn = self.$compile elm
            linkFn self.$scope
        testRows = (elm, expected) ->
            elements = elm.find("tr")
            lenTr = 0
            angular.forEach elements, (value) ->
                el = angular.element value
                if el.hasClass 'sectir-table-header'
                    lenTr++
            expect(lenTr).toBe(expected)
        el1 = compile tree1, "default"
        testRows el1, 2
        el2 = compile tree2, "another"
        testRows el2, 3
        el3 = compile tree3, "and_another_one"
        testRows el3, 5


    it 'should have a sectir-delete header when table is created', ->
        @$scope.tabledata =
            id: 1
            name: "My Name"
            children:
                [
                    {
                        id: 2
                        name: "Name 2"
                    }
                    {
                        id: 3
                        name: "Name 3"
                    }
                ]
        elm = angular.element '''
                <sectir-table tabledata="tabledata" namespace="name">
                </sectir-table>
            '''
        elm = @$compile(elm)(@$scope)
        headers = elm.find "th"
        numberOfHeaders = 0
        angular.forEach headers, (value) ->
            el = angular.element value
            if el.hasClass 'sectir-delete'
                numberOfHeaders++
        expect(numberOfHeaders).toBe(1)
    
    describe 'tests for colspan and rowspan', ->
        beforeEach ->
            @tree1 =
                id: 1
                name: "A name"
                children:
                    [
                        {
                            id: 2
                            name: "Second name"
                            children:
                                [
                                    {
                                        id: 3
                                        name: "Third name"
                                    }
                                ]
                        }
                        {
                            id: 4
                            name: "Fourth name"
                        }
                        {
                            id: 5
                            name: "Fifth name"
                        }
                    ]
            @tree2 =
                id: 1
                name: "Only name"
            @tree3 =
                id: 1
                name: "A name"
                children:
                    [
                        {
                            id: 2
                            name: "Second name"
                        }
                        {
                            id: 3
                            name: "Third name"
                        }
                    ]
            @compileEl = (data) ->
                
                @$scope.tabledata = data
                elm = angular.element '''
                    <sectir-table
                        tabledata="tabledata">
                    </sectir-table>
                '''
                @$compile(elm)(@$scope)
        it 'should give a correct colspan and rowspan for sectir-delete', ->
            findSectirDelete = (elm, rowspan) ->
                colspans = []
                rowspans = []
                headers = elm.find "th"
                angular.forEach headers, (value) ->
                    el = angular.element value
                    if el.hasClass "sectir-delete"
                        rowspans.push(el.attr("rowspan"))
                        colspans.push(el.attr("colspan"))
                expect(colspans).toEqual(['1'])
                expect(rowspans).toEqual(rowspan)
            #for val in [@tree1, @tree2, @tree3]
            #    findSectirDelete(@compileEl(val))
            findSectirDelete(@compileEl(@tree1),['3'])
            findSectirDelete(@compileEl(@tree2),['1'])
            findSectirDelete(@compileEl(@tree3),['2'])
