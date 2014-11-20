angular.module('sectirTableModule.pager',
    [
        'sectirTableModule.dataFactory'
        'sectirTableModule.input'
        'sectirTableModule.table'
        'sectirTableModule.groupinput'
    ]
)
    .directive 'sectirPager', [
        "$compile"
        ($compile) ->
            {
                restrict: "EA"
                scope:
                    values: "="
                    settings: "=?"
                    finalizefunc: "&"
                controller: ["$scope", ($scope) ->
                    $scope.currPos = 0
                    $scope.nextButtonClick = ->
                        if $scope.isNextButtonClickable()
                            $scope.currPos++
                        return
                    $scope.prevButtonClick = ->
                        if $scope.isPrevButtonClickable()
                            --$scope.currPos
                        return
                    $scope.isPrevButtonClickable = ->
                        $scope.currPos > 0
                    $scope.isNextButtonClickable = ->
                        $scope.currPos < ($scope.values.length - 1)
                    $scope.isFinalizeButtonClickable = ->
                        $scope.finalizefunc and
                            $scope.currPos is ($scope.values.length - 1)
                    $scope.nextButtonText = "Siguiente"
                    $scope.prevButtonText = "Anterior"
                    $scope.finalizeButtonText = "Finalizar"
                ]
                link: (scope, element, attrs, ctrl) ->
                    #No quiero estar revisando values a cada rato
                    myValues = angular.copy(
                        scope.values
                    )
                    divWholeContainer = angular.element "<div>"
                    divWholeContainer.addClass "sectir-pager-wholecontainer"
                    isSettingsDefined = {}
                    isSettingsDefined["all"] = angular.isDefined scope.settings
                    for t in ["input", "table", "groupinput"]
                        isSettingsDefined[t] = isSettingsDefined["all"] and
                            angular.isDefined scope.settings[t]
                    for val, i in myValues
                        divContainer = angular.element "<div>"
                        divContainer.addClass "sectir-pager-container"
                        switch val.type
                            when "input"
                                directive = angular.element "<sectir-input>"
                            when "table"
                                directive = angular.element "<sectir-table>"
                            when "groupinput"
                                directive = angular.element(
                                    "<sectir-group-input>"
                                )
                            else
                                throw new Error(
                                    '''Type must be input, table
                                    or group-input'''
                                )
                        if isSettingsDefined[val.type]
                            for key of scope.settings[val.type]
                                directive.attr key,
                                    "settings.#{val.type}.#{key}"
                        valueVariable =
                            switch val.type
                                when "input", "groupinput"
                                    "scopedata"
                                when "table"
                                    "tabledata"
                                else
                                    ""
                        directive.attr valueVariable, "values[#{i}].values"
                        directive.attr "namespace", "values[#{i}].namespace"
                        #Ponemos valores de directiva
                        divContainer.attr "ng-show", "currPos === #{i}"
                        divContainer.append directive
                        divWholeContainer.append divContainer
                    #Button Row
                    buttonDivRow = angular.element "<div>"
                    buttonDivRow.addClass "sectir-pager-button-row"
                    #Botón anterior
                    buttonPrev = angular.element "<button>"
                    buttonPrev.addClass "sectir-pager-prev-button"
                    buttonPrev.text "{{ prevButtonText }}"
                    buttonPrev.attr "ng-click", "prevButtonClick()"
                    buttonPrev.attr "ng-disabled",
                        "!isPrevButtonClickable()"
                    #Botón siguiente
                    buttonNext = angular.element "<button>"
                    buttonNext.addClass "sectir-pager-next-button"
                    buttonNext.text "{{ nextButtonText }}"
                    buttonNext.attr "ng-click", "nextButtonClick()"
                    buttonNext.attr "ng-disabled",
                        "!isNextButtonClickable()"
                    #Button Final
                    buttonFinal = angular.element "<button>"
                    buttonFinal.addClass "sectir-pager-final-button"
                    buttonFinal.text "{{ finalizeButtonText }}"
                    buttonFinal.attr "ng-click", "finalizefunc()"
                    buttonFinal.attr "ng-disabled",
                        "!isFinalizeButtonClickable()"
                    buttonDivRow.append buttonPrev
                    buttonDivRow.append buttonNext
                    buttonDivRow.append buttonFinal
                    divWholeContainer.append buttonDivRow
                    $compile(divWholeContainer)(scope)
                    element.append divWholeContainer

            }
    ]
