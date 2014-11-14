angular.module('sectirTableModule.table',
    [
        'sectirTableModule.treeFactory'
        'sectirTableModule.dataFactory'
    ]
)
    .directive 'sectirTable', [
        "sectirTreeFactory"
        "sectirDataFactory"
        "$compile"
        (sectirTreeFactory, sectirDataFactory, $compile) ->
            defaultValues =
                namespace: "default"
                deletefieldlabel: "Delete"
                debugmodel: false
                deletelabel: "Delete"
                typefield: "type"
                titlefield: "name"
                optionsfield: "options"
                addlabel: "Add"
                addfieldlabel: "Add"

            {
                restrict: "EA"
                scope:
                    namespace: "=?"
                    tabledata: "="
                    titlefield: "=?"
                    deletelabel: "=?"
                    deletefieldlabel: "=?"
                    addfieldlabel: "=?"
                    addlabel: "=?"
                    typefield: "=?"
                    debugmodel: "=?"
                    optionsfield: "=?"
                controller: ["$scope", ($scope) ->
                    @getLeafs = ->
                        sectirTreeFactory.getLeafs
                        $scope.namespace
                ]
                link: (scope, element, attrs, ctrl) ->
                    linkFn = ->
                        for key, value of defaultValues
                            if not angular.isDefined scope[key]
                                scope[key] = value
                        sectirTreeFactory.addTree(scope.tabledata,
                            scope.namespace)
                        rows = sectirTreeFactory.getRows scope.namespace
                        remainingTable = element.find "table"
                        if angular.isElement remainingTable
                            remainingTable.remove()
                        table = angular.element "<table>"
                        table.addClass "sectir-table"
                        firstRow = true
                        trRows = []
                        for row in rows
                            headers = []
                            tr = angular.element "<tr>"
                            tr.addClass "sectir-table-header"
                            for field in row
                                elm = angular.element("<th>")
                                elm.text field.model[scope.titlefield]
                                elm.addClass "sectir-header"
                                elm.attr "colspan",
                                    sectirTreeFactory.getNumberLeafsFromNode(
                                        field.model.id, scope.namespace)
                                rowspan = do ->
                                    hasChildren = sectirTreeFactory.
                                        hasChildrenById(
                                            field.model.id, scope.namespace
                                        )
                                    if not hasChildren
                                        sectirTreeFactory.
                                        getNodeLevelsFromMax(field.model.id,
                                            scope.namespace) + 1
                                    else
                                        1
                                elm.attr "rowspan", rowspan
                                headers.push elm
                            if firstRow
                                firstRow = false
                                treeHeight = sectirTreeFactory.
                                    getTreeHeight scope.namespace
                                elm = angular.element "<th>"
                                elm.addClass "sectir-delete"
                                spanDeleteLabel = angular.element "<span>"
                                spanDeleteLabel.text "{{ deletelabel }}"
                                elm.append spanDeleteLabel
                                elm.attr "colspan", 1
                                elm.attr "rowspan", treeHeight
                                elmAdd = angular.element "<th>"
                                elmAdd.addClass "sectir-add"
                                spanAddLabel = angular.element "<span>"
                                spanAddLabel.text "{{ addlabel }}"
                                elmAdd.append spanAddLabel
                                elmAdd.attr "colspan", 1
                                elmAdd.attr "rowspan", treeHeight
                                headers.push elmAdd
                                headers.push elm
                            for val in headers
                                tr.append val
                            trRows.push tr
                        for val in trRows
                            table.append val
                        scope.answersObject = {}
                        templateAnswers = do ->
                            leafs =
                                sectirTreeFactory.getLeafs scope.namespace
                            rowRepeat = angular.element "<tr>"
                            rowRepeat.attr("ng-repeat",
                                "ans in answersObject.values")
                            rowRepeat.addClass "sectir-ans-row"
                            ngModelRow = (modelId) ->
                                temp = "answersObject.values[$index]"
                                temp += "['#{modelId}']"
                                temp
                            index = 0
                            #Aquí empezamos a poner valores
                            leafsByPre = sectirTreeFactory.
                                getLeafs scope.namespace, "pre"
                            for l in leafsByPre
                                headerRepeat = angular.element "<th>"
                                headerRepeat.addClass "sectir-answer"
                                rowModel = ngModelRow l.model.id
                                typefieldDefined = angular.isDefined(
                                    l.model[scope.typefield]
                                )
                                if typefieldDefined \
                                        and l.model[scope.typefield] is "select"
                                    input = angular.element "<select>"
                                else
                                    input = angular.element "<input>"
                                input.attr "ng-model", rowModel
                                if typefieldDefined
                                    input.attr "type", l.model[scope.typefield]
                                if angular.isDefined
                                    l.model[scope.optionsfield]
                                    options = l.model[scope.optionsfield]
                                    for key, value of options
                                        input.attr key, value
                                if scope.debugmodel
                                    iEl = angular.element "<i>"
                                    iEl.addClass "sectir-debug-model"
                                    iEl.text "{{ #{rowModel} }}"
                                headerRepeat.append input
                                if scope.debugmodel
                                    headerRepeat.append iEl
                                rowRepeat.append headerRepeat
                                index++
                            deleteButton = angular.element "<th>"
                            deleteButton.addClass "sectir-button-delete"
                            spanDelete = angular.element "<span>"
                            spanDelete.attr "ng-click", "deleteAnswer($index)"
                            spanDelete.text "{{ deletefieldlabel }}"
                            deleteButton.append spanDelete
                            addButton = angular.element "<th>"
                            addButton.addClass "sectir-button-add"
                            spanAdd = angular.element "<span>"
                            spanAdd.attr "ng-click", "addAnswer()"
                            spanAdd.text "{{ addfieldlabel }}"
                            addButton.append spanAdd
                            rowRepeat.append addButton
                            rowRepeat.append deleteButton
                            rowRepeat
                                
                        elmAnswers = templateAnswers
                        table.append elmAnswers
                        $compile(table)(scope)
                        element.append table
                        scope.answersObject.values = []
                        scope.addAnswer = ->
                            scope.answersObject.values.push {}
                        scope.deleteAnswer = (index) ->
                            scope.answersObject.values.splice index, 1
                            if scope.answersObject.values.length < 1
                                scope.addAnswer()
                        scope.addAnswer()
                    watchFn = ->
                        [
                            scope.namespace
                            scope.tabledata
                        ]
                    linkFn()

                    scope.$watch watchFn, linkFn, true
                    scope.$watch "answersObject", ->
                        sectirDataFactory.saveData(
                            scope.answersObject
                            scope.namespace
                        )
            }
    ]
