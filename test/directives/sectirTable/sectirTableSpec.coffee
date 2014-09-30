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

    it 'should update a table when values of tabledata
        and namespace are changed', ->
        @$scope.tabledata =
            id: 1
            name: "My name"
        @$scope.namespace = "namespace"
        elm = angular.element '''
            <sectir-table tabledata="tabledata" namespace="namespace">
            </sectir-table>
        '''
        elm = @$compile(elm)(@$scope)
        findHeaders = ->
            text = []
            headers = elm.find("th")
            angular.forEach headers, (value) ->
                el = angular.element value
                if el.hasClass 'sectir-header'
                    text.push(el.text())
            text
        expect(findHeaders()).toEqual(["My name"])
        @$scope.$apply =>
            @$scope.tabledata.name = "My name 2"
        expect(findHeaders()).toEqual(["My name 2"])
        @$scope.$apply =>
            @$scope.tabledata.name = "My name 3"
            @$scope.tabledata.namespace = "namespace2"
        expect(findHeaders()).toEqual(["My name 3"])
        
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
        numberOfAddHeaders = 0
        angular.forEach headers, (value) ->
            el = angular.element value
            if el.hasClass 'sectir-delete'
                numberOfHeaders++
            else if el.hasClass 'sectir-add'
                numberOfAddHeaders++
        expect(numberOfHeaders).toBe(1)
        expect(numberOfAddHeaders).toBe(1)
    
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
            @tree4 =
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
                    ]
            @compileEl = (data, namespace = "default") ->
                
                @$scope.tabledata = data
                @$scope.namespace = namespace
                elm = angular.element '''
                    <sectir-table
                        tabledata="tabledata"
                        namespace="namespace"
                        >
                    </sectir-table>
                '''
                @$compile(elm)(@$scope)
            @checkColRowSpan = (data, rowspan, colspan) ->
                elm = @compileEl data
                rowspanArray = []
                colspanArray = []
                headers = elm.find "th"
                angular.forEach headers, (value) ->
                    tempEl = angular.element value
                    if tempEl.hasClass "sectir-header"
                        colspanArray.push tempEl.attr "colspan"
                        rowspanArray.push tempEl.attr "rowspan"
                expect(colspanArray).toEqual(colspan)
                expect(rowspanArray).toEqual(rowspan)

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
            findSectirDelete(@compileEl(@tree3, "other"),['2'])

        it 'should check correct properties in sectir-header', ->
            # Tree 1
            rowspan1 =
                [
                    # Primer nivel
                    '1'
                    # Segundo nivel
                    '1'
                    '2'
                    '2'
                    # Tercer nivel
                    '1'
                ]
            colspan1 =
                [
                    # Primer nivel
                    '3'
                    # Segundo nivel
                    '1'
                    '1'
                    '1'
                    # Tercer nivel
                    '1'
                ]
            @checkColRowSpan @tree1, rowspan1, colspan1

            # Tree 2
            rowspan2 =
                [
                    #Primer nivel
                    '1'
                ]
            colspan2 =
                [
                    '1'
                ]
            @checkColRowSpan @tree2, rowspan2, colspan2

            # Tree 3
            rowspan3 =
                [
                    # Primer nivel
                    '1'
                    # Segundo nivel
                    '1'
                    '1'
                ]
            colspan3 =
                [
                    # Primer nivel
                    '2'
                    # Segundo nivel
                    '1'
                    '1'
                ]
            @checkColRowSpan @tree3, rowspan3, colspan3
            
            #Tree 4
            rowspan4 =
                [
                    # Primer nivel
                    '1'
                    # Segundo nivel
                    '1'
                    '2'
                    # Tercer nivel
                    '1'
                ]
            colspan4 =
                [
                    # Primer nivel
                    '2'
                    # Segundo nivel
                    '1'
                    '1'
                    # Tercer nivel
                    '1'
                ]
    describe 'Tests for input', ->
        beforeEach ->
            @treeWithSelect =
                id: 1
                name: "Select"
                type: "select"
                options:
                    "ng-options": "o for o in [2, 3, 5]"
            @treeWithOtherProperties =
                id: 1
                name: "Header"
                children:
                    [
                        {
                            id: 2
                            name: "A checkbox"
                            type: "checkbox"
                            options:
                                name: "checkbox_name"
                        }
                        {
                            id: 3
                            name: "A father node of email"
                            children:
                                [
                                    {
                                        id: 4
                                        name: "A email"
                                        type: "email"
                                        options:
                                            "ng-maxlength": 60
                                    }
                                ]
                        }
                    ]
            @treeWithDiffOptionField =
                id: 1
                type: "text"
                name: "A name"
                opciones:
                    "ng-minlength": 3
            @treeWithDiffTitleField =
                id: 1
                type: "text"
                nombre: "Un nombre"
            @treeWithDiffTypeField =
                id: 1
                tipo: "email"
                name: "A name"
            @compileEl = (options) ->
                @myScope = @$scope.$new()
                elm = angular.element "<sectir-table>"
                for key, value of options
                    elm.attr key, key
                    @myScope[key] = value
                retVal = @$compile(elm)(@myScope)
                @myScope.$digest()
                retVal
        it 'should create a correct <select> input type', ->
            options = do =>
                tabledata: @treeWithSelect
            elm = @compileEl options
            select = elm.find "select"
            numberSelects = 0
            ngOptions = []
            angular.forEach select, (value) ->
                numberSelects++
                el = angular.element value
                ngOpt = el.attr "ng-options"
                if ngOpt?
                    ngOptions.push ngOpt
            expect(numberSelects).toBe(1)
            expect(ngOptions).toEqual(["o for o in [2, 3, 5]"])
        it 'should create an input type correctly', ->
            options =
                do =>
                    tabledata: @treeWithOtherProperties
            elm = @compileEl options
            inputs = elm.find "input"
            inputTestArray = []
            angular.forEach inputs, (value) ->
                el = angular.element value
                inputTestArray.push(el.attr("type"))
            expect(inputTestArray.length).toBe(2)
            expect(inputTestArray).toEqual(["checkbox","email"])
        it 'should pass correct options no matter the name of those ones', ->
            options =
                do =>
                    tabledata: @treeWithDiffOptionField
                    optionsfield: "opciones"
            elm = @compileEl options
            input = elm.find "input"
            attrs = []
            angular.forEach input, (value) ->
                el = angular.element value
                attrs.push(el.attr("ng-minlength"))
            expect(attrs).toEqual(["3"])

            options2 =
                do =>
                    tabledata: @treeWithDiffTitleField
                    titlefield: "nombre"
            texts = []
            elm = @compileEl options2
            headers = elm.find "th"
            angular.forEach headers, (value) ->
                el = angular.element value
                if el.hasClass "sectir-header"
                    texts.push(el.text())
            expect(texts).toEqual(["Un nombre"])

            options3 =
                do =>
                    tabledata: @treeWithDiffTypeField
                    typefield: "tipo"
            types = []
            elm = @compileEl options3
            inputs = elm.find "input"
            angular.forEach inputs, (value) ->
                el = angular.element value
                types.push(el.attr("type"))
            expect(types).toEqual(["email"])
        it 'answer row should have sectir-answer and sectir-button classes', ->
            options =
                do =>
                    tabledata: @treeWithOtherProperties
            elm = @compileEl options
            headers = elm.find "th"
            countHeaders = 0
            countAdd = 0
            countDelete = 0
            angular.forEach headers, (value) ->
                el = angular.element value
                if el.hasClass "sectir-answer"
                    countHeaders++
                else if el.hasClass "sectir-button-add"
                    countAdd++
                else if el.hasClass "sectir-button-delete"
                    countDelete++
            expect(countHeaders).toBe(2)
            expect(countAdd).toBe(1)
            expect(countDelete).toBe(1)
        it 'should add and delete elements when clicks are triggered', ->
            options =
                do =>
                    tabledata: @treeWithOtherProperties
            #Test add
            elm = @compileEl options
            row = elm.find("tr").eq(3)
            #Let's click add
            row.find("th").eq(2).find("span").triggerHandler("click")
            @myScope.$digest()
            count = (expected) ->
                rows = elm.find("tr")
                countRows = 0
                angular.forEach rows, (value) ->
                    el = angular.element value
                    if el.hasClass "sectir-ans-row"
                        countRows++
                expect(countRows).toBe(expected)
            count(2)
            #click delete
            row.find("th").eq(3).find("span").triggerHandler("click")
            @myScope.$digest()
            count(1)
            #click delete again
            row.find("th").eq(3).find("span").triggerHandler("click")
            @myScope.$digest()
            #it must be 1 again
            count(1)
