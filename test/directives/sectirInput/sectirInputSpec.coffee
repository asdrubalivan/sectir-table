describe 'sectirInput', ->
    @$scope = undefined
    @$compile = undefined

    beforeEach(module('sectirTableModule'))

    beforeEach(inject(($compile, $rootScope, sectirDataFactory) ->
        @$scope = $rootScope
        @$compile = $compile
        @sdf = sectirDataFactory
        @myInput =
            {
                "input1":
                    [
                        {
                            id: "1"
                            name: "Seleccioname"
                            type: "select"
                            options:
                                "ng-options": "o for o in [4, 5, 9]"
                            
                        }
                        {
                            id: "2"
                            name: "Un email"
                            type: "email"
                        }
                    ]

            }
        @createElement = ->
            elm = angular.element '''
                <sectir-input
                    scopedata="data"
                    namespace="namespace"
                >
                </sectir-input>
            '''
            @$compile elm
    ))
    
    describe 'checking default options', ->
        beforeEach ->
            @key = "input1"
            @$scope.data = @myInput[@key]
            @$scope.namespace = @key
            linkFn = @createElement()
            @elm = linkFn @$scope

            #Setting spy
            spyOn @sdf, "saveData"

        it 'should contain correct ng-models', ->
            mainDiv = @elm.find "div"
            rows = mainDiv.eq(0).find("div")
            expect(rows.children().eq(0).text()).toBe("Seleccioname")
            expect(rows.children().eq(3).text()).toBe("Un email")
            expect(rows.children().eq(1).find("select")
                .attr("ng-model"))
                .toBe("answersObject['1']")
            expect(rows.children().eq(4).find("input")
                .attr("ng-model"))
                .toBe("answersObject['2']")

        it 'should contain correct input labels', ->
            rows = @elm.find("div").eq(0).find("div")
            expect(rows.children().eq(4).find("input").attr("type"))
                .toBe("email")
        it 'should call DataFactory', ->
            rows = @elm.find("div").eq(0).find("div")
            @$scope.$digest()
            firstInput = rows.children()
                .eq(1)
                .find("select")
                .eq(0)
                .val(2)
            firstInput.triggerHandler("change")
           # console.log @$scope
            data =
                "1": 9
            console.log @sdf
            expect(@sdf.saveData).toHaveBeenCalledWith data, @key

            secondInput = rows.children()
                .eq(4)
                .find("input")
                .val("1@a.com")
                .triggerHandler("change")
            data["2"] = "1@a.com"
            expect(@sdf.saveData).toHaveBeenCalledWith data, @key
