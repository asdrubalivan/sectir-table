describe 'sectirPager', ->
    @$scope = undefined
    @$compile = undefined

    beforeEach(module('sectirTableModule'))

    beforeEach(inject(($compile, $rootScope, sectirDataFactory) ->
        @$scope = $rootScope
        @$compile = $compile
        @sdf = sectirDataFactory
        @$scope.func = ->
        @$scope.mySettings =
            settings1:
                input:
                    debugmodel: true
                table:
                    optionsfield: "opciones"
                    deletelabel: "Borrar"
        @$scope.sectirPagerInput =
            [
                {
                    type: "input"
                    namespace: "input"
                    values:
                        [
                            {
                                id: "1"
                                name: "My select"
                                type: "select"
                                options:
                                    "ng-options": "x for x in [1, 2, 3, 5]"
                            }
                            {
                                id: "2"
                                name: "An email"
                                type: "email"
                            }
                        ]
                }
                {
                    type: "groupinput"
                    namespace: "groupinput"
                    values:
                        [
                            {
                                id: "1-1"
                                name: "My select"
                                type: "select"
                                options:
                                    "ng-options": "x for x in [1, 2, 3, 5]"
                            }
                            {
                                id: "1-2"
                                name: "An email"
                                type: "second email"
                            }
                       ]
                    
                }
                {
                    type: "table"
                    namespace: "table"
                    values:
                        {
                            id: 3
                            name: "Header"
                            children:
                                [
                                    {
                                        id: 4
                                        name: "Header 2"
                                        children:
                                            [
                                                {
                                                    id: 5
                                                    name: "Header 3"
                                                }
                                                {
                                                    id: 6
                                                    name: "Header 4"
                                                }
                                            ]
                                    }
                                    {
                                        id: 7
                                        name: "Header 5"
                                    }
                                ]
                        }
                }
            ]

        @createElement = (settings = false) ->
            elm = angular.element '''
                <sectir-pager
                    values="sectirPagerInput"
                    finalizefunc = "func()"
                >
                </sectir-pager>
            '''
            if settings isnt false
                elm.attr "settings", "mySettings['#{settings}']"
            @$compile(elm)(@$scope)
    ))
    
    it 'should show buttons correctly', ->
        elm = @createElement()
        @$scope.$digest()
        buttons = elm.find "button"
        expect(buttons.eq(0).hasClass("sectir-pager-prev-button")).toBe(true)
        expect(buttons.eq(1).hasClass("sectir-pager-next-button")).toBe(true)
        expect(buttons.eq(2).hasClass("sectir-pager-final-button")).toBe(true)
        expect(buttons.eq(0).attr("disabled")).toBe("disabled")
        expect(buttons.eq(1).attr("disabled")).not.toBe("disabled")
        expect(buttons.eq(2).attr("disabled")).toBe("disabled")
        buttons.eq(1).triggerHandler("click")
        @$scope.$digest()
        expect(buttons.eq(0).attr("disabled")).not.toBe("disabled")
        buttons.eq(1).triggerHandler("click")
        @$scope.$digest()
        expect(buttons.eq(0).attr("disabled")).not.toBe("disabled")
        expect(buttons.eq(1).attr("disabled")).toBe("disabled")
    
    it 'should call function passed as reference', ->
        spyOn @$scope, "func"
        elm = @createElement()
        @$scope.$digest()
        buttons = elm.find "button"
        buttons.eq(2).triggerHandler("click")
        @$scope.$digest()
        expect(@$scope.func).toHaveBeenCalled()
    
    it 'should check settings are passed to directives', ->
        elm = @createElement "settings1"
        expect(elm.find("sectir-input").eq(0).attr("debugmodel"))
            .toBe("settings.input.debugmodel")
        expect(elm.find("sectir-table").eq(0).attr("optionsfield"))
            .toBe("settings.table.optionsfield")
        expect(elm.find("sectir-table").eq(0).attr("deletelabel"))
            .toBe("settings.table.deletelabel")
        expect(elm.find("sectir-table").eq(0).attr("titlefield"))
            .not.toBeDefined()
    it 'should pass attributes "scopedata" or "tabledata" to child dir', ->
        elm = @createElement()
        expect(elm.find("sectir-table").eq(0).attr("tabledata"))
            .toBeDefined()
        expect(elm.find("sectir-table").eq(0).attr("scopedata"))
            .not.toBeDefined()
        expect(elm.find("sectir-input").eq(0).attr("scopedata"))
            .toBeDefined()
        expect(elm.find("sectir-input").eq(0).attr("tabledata"))
            .not.toBeDefined()
        expect(elm.find("sectir-group-input").eq(0).attr("tabledata"))
            .not.toBeDefined()
        expect(elm.find("sectir-group-input").eq(0).attr("scopedata"))
            .toBeDefined()
        #Check attribute values
        expect(elm.find("sectir-group-input").eq(0).attr("scopedata"))
            .toBe("values[1].values")
        expect(elm.find("sectir-group-input").eq(0).attr("namespace"))
            .toBe("values[1].namespace")
        expect(elm.find("sectir-input").eq(0).attr("scopedata"))
            .toBe("values[0].values")
        expect(elm.find("sectir-input").eq(0).attr("namespace"))
            .toBe("values[0].namespace")
        expect(elm.find("sectir-table").eq(0).attr("tabledata"))
            .toBe("values[2].values")
        expect(elm.find("sectir-table").eq(0).attr("namespace"))
            .toBe("values[2].namespace")


    it 'should show or not directives', ->
        elm = @createElement()
        expect(elm.find("sectir-input").parent().eq(0).attr("ng-show"))
            .toBe("currPos === 0")
        expect(elm.find("sectir-group-input").parent().eq(0).attr("ng-show"))
            .toBe("currPos === 1")
        expect(elm.find("sectir-table").parent().eq(0).attr("ng-show"))
            .toBe("currPos === 2")
