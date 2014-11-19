describe 'sectirGroupInput', ->
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
                <sectir-group-input
                    scopedata="data"
                    namespace="namespace"
                >
                </sectir-group-input>
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
            rows = @elm.find "tr"
            expect(rows.length).toBe(2)
            expect(rows.eq(0).find("td").eq(0).text()).toBe("Seleccioname")
            expect(rows.eq(1).find("td").eq(0).text()).toBe("Un email")
            expect(rows.eq(0).find("td").eq(1).find("select")
                .attr("ng-model"))
                .toBe("answersObject['1']")
            expect(rows.eq(1).find("td").eq(1).find("input")
                .attr("ng-model"))
                .toBe("answersObject['2']")

        it 'should contain correct input labels', ->
            rows = @elm.find "tr"
            expect(rows.eq(1).find("td").eq(1).find("input").eq(0).attr("type"))
                .toBe("email")
        it 'should call DataFactory', ->
            rows = @elm.find "tr"
            @$scope.$digest()
            firstInput = rows.eq(0)
                .find("td")
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

            secondInput = rows.eq(1)
                .find("td")
                .eq(1)
                .find("input")
                .val("1@a.com")
                .triggerHandler("change")
            data["2"] = "1@a.com"
            expect(@sdf.saveData).toHaveBeenCalledWith data, @key
