angular.module('sectirTableModule.input',
    [
        'sectirTableModule.dataFactory'
    ]
)
    .directive 'sectirInput', [
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
                    typefield: "=?"
                    debugmodel: "=?"
                    namefield: "=?"
                    optionsfield: "=?"
                    scopedata: "="
                link: (scope, element, attrs, ctrl) ->
                    linkFn = ->
                        for key, value of defaultValues
                            if not angular.isDefined scope[key]
                                scope[key] = value

                        wrapDiv = angular.element "<div>"
                        wrapDiv.addClass "sectir-input-main"
                        for val in scope.scopedata
                            currObjectName = "answersObject['#{val.id}']"

                            elmWrapper = angular.element "<div>"
                            elmWrapper.addClass "sectir-input-wrapper"
                            elmName = angular.element "<div>"
                            elmName.addClass "sectir-input-namefield"
                            elmName.text val[scope.namefield]
                            type = if val[scope.typefield] is "select"
                                "select"
                            else
                                "input"
                            elm = angular.element "<#{type}>"
                            elm.attr "ng-model", currObjectName
                            if angular.isDefined val[scope.optionsfield]
                                for key, value of val[scope.optionsfield]
                                    elm.attr key, value
                            elmWrapper.append elmName
                            elmWrapper.append elm
                            if scope.debugmodel
                                elmDebug = angular.element "<div>"
                                elmDebug.text "{{#{currObjectName}}}"
                                elmWrapper.append elmDebug
                            wrapDiv.append elmWrapper
                        scope.answersObject = {}
                        $compile(wrapDiv)(scope)
                        element.append wrapDiv
                    watchFn = ->
                        [
                            scope.namespace
                            scope.scopedata
                        ]
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
