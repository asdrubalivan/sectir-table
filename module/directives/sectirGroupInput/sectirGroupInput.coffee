angular.module('sectirTableModule.groupinput',
    [
        'sectirTableModule.dataFactory'
    ]
)
    .directive 'sectirGroupInput', [
        "sectirDataFactory"
        "$compile"
        (sectirDataFactory, $compile) ->
            defaultValues =
                namespace: "default"
                debugmodel: false
                typefield: "type"
                namefield: "name"
                optionsfield: "options"

            {
                restrict: "EA"
                scope:
                    namespace: "=?"
                    tabledata: "="
                    namefield: "=?"
                    typefield: "=?"
                    debugmodel: "=?"
                    optionsfield: "=?"
                    scopedata: "="
                link: (scope, element, attrs, ctrl) ->
                    scope.answersObject = {}
                    linkFn = ->
                        for key, value of defaultValues
                            if not angular.isDefined scope[key]
                                scope[key] = value
                        
                        wrapTable = angular.element "<table>"
                        wrapTable.addClass "sectir-groupinput-main"
                        for val in scope.scopedata
                            currObjName = "answersObject['#{val.id}']"
                            elmWrapper = angular.element "<tr>"
                            elmWrapper.addClass "sectir-groupinput-wrapper"
                            elmName = angular.element "<td>"
                            elmName.addClass "sectir-groupinput-namefield"
                            elmName.text val[scope.namefield]
                            type = if val[scope.typefield] is "select"
                                "select"
                            else
                                "input"
                            
                            elm = angular.element "<#{type}>"
                            if type is "input"
                                elm.attr "type", val[scope.typefield]
                            elm.attr "ng-model", currObjName
                            if angular.isDefined val[scope.optionsfield]
                                for key, value of val[scope.optionsfield]
                                    elm.attr key, value
                            elmWrapper.append elmName
                            cellWithInput = angular.element "<td>"
                            cellWithInput.addClass "sectir-groupinput-cell"
                            cellWithInput.append elm
                            elmWrapper.append cellWithInput
                            if scope.debugmodel
                                elmDebug = angular.element "<td>"
                                elmDebug.text "{{#{currObjName}}}"
                                elmWrapper.append elmDebug
                            wrapTable.append elmWrapper
                        $compile(wrapTable)(scope)
                        element.append wrapTable
                        return

                        
                    #watchFn = ->
                    #    [
                    #        scope.namespace
                    #        scope.scopedata
                    #    ]
                    linkFn()
                    #scope.$watch watchFn, linkFn, true
                    scope.$watch "answersObject", ->
                        console.log "Guardando datos"
                        sectirDataFactory.saveData(
                            scope.answersObject
                            scope.namespace
                        )
                       , true
            }
    ]
