angular.module('sectirTableModule.table',
    [
        'sectirTableModule.treeFactory'
        'sectirTableModule.treeModelFactory'
        'sectirTableModule.dataFactory'
        'ngTagsInput'
    ]
)
    .directive 'sectirTable', [
        "sectirTreeFactory"
        "sectirDataFactory"
        "treeModelFactory"
        "$compile"
        (sectirTreeFactory, sectirDataFactory, treeModelFactory , $compile) ->
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
                subquestions: false
                subqenun: "enunciado"
                anocomienzo: false
                anofinal: false

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
                    subquestions: "=?"
                    subqenun: "=?"
                    anocomienzo: "=?"
                    anofinal: "=?"
                controller: ["$scope", ($scope) ->
                        for key, value of defaultValues
                            if not angular.isDefined $scope[key]
                                $scope[key] = value
                        $scope.answersObject = {}
                        $scope.needObject = ->
                            subQFn = (node) ->
                               node.model[$scope.typefield] is "subq"
                            aTree = treeModelFactory.parse(
                                $scope.tabledata
                            )
                            first = aTree.first subQFn
                            $scope.subquestions instanceof Array or
                                first
                        if not $scope.needObject()
                            $scope.answersIsArray = true
                            $scope.answersObject.hasSubQ = false
                            $scope.answersObject.values = []
                        else
                            $scope.answersIsArray = false
                            $scope.answersObject.hasSubQ = true
                            $scope.answersObject.values = {}
                        $scope.addAnswer = ->
                            if $scope.answersIsArray
                                $scope.answersObject.values.push {}
                        $scope.deleteAnswer = (index) ->
                            $scope.answersObject.values.splice index, 1
                            if $scope.answersObject.values.length < 1
                                $scope.addAnswer()
                        $scope.subqtitle = "Opciones"

                ]
                link: (scope, element, attrs, ctrl) ->
                    linkFn = ->
                        # No mandamos Un año a la factory
                        # ya que no queremos que la misma
                        # cree los nodos con las respuestas
                        # para los años
                        sectirTreeFactory.addTree(
                            scope.tabledata
                            scope.namespace
                            scope.titlefield
                            scope.typefield
                            #scope.anocomienzo
                            #scope.anofinal
                        )
                        treeToBeRefactored = sectirTreeFactory
                            .trees[scope.namespace]
                        console.log treeToBeRefactored
                        subQNodes = []
                        dropRefactorFn = (node) ->
                            node.model[scope.typefield] is "subq"
                        forEachRefactorFn = (node) ->
                            node.drop()
                            subQNodes = subQNodes.concat node.model.subq
                        treeToBeRefactored
                            .all(dropRefactorFn)
                            .forEach(forEachRefactorFn)
                        if subQNodes.length
                            scope.subquestions = subQNodes
                        haveSubQuestions = scope.subquestions\
                        or subQNodes.length
                        sectirTreeFactory.addTree(
                            scope.tabledata
                            scope.namespace
                            scope.titlefield
                            scope.typefield
                            scope.anocomienzo
                            scope.anofinal
                        )
                        rows = sectirTreeFactory.getRows scope.namespace
                        remainingTable = element.find "table"
                        if angular.isElement remainingTable
                            remainingTable.remove()
                        table = angular.element "<table>"
                        table.addClass "sectir-table"
                        firstRow = true
                        trRows = []
                        for row, ix in rows
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
                                if not haveSubQuestions
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
                            if (ix is rows.length - 1) and haveSubQuestions
                                elm = angular.element "<th>"
                                elm.addClass "sectir-subq-title"
                                elm.text "{{subqtitle}}"
                                elm.attr "colspan", 1
                                elm.attr "rowspan", 1
                                #No podemos hacer push como arriba
                                #ya que tenemos que agregar los elementos
                                #al inicio
                                #y no al final
                                headers.unshift elm
                            for val in headers
                                tr.append val
                            trRows.push tr
                        for val in trRows
                            table.append val
                        #scope.answersObject = {}
                        ngModelRow = (modelId, subQID = false) ->
                            temp = "answersObject.values"
                            if subQID is false
                                temp += "[$index]"
                            temp += "['#{modelId}']"
                            if subQID isnt false
                                temp += "['#{subQID}']"
                            temp

                        templateAnswersFn = (subQuestion = false) ->
                            leafs =
                                sectirTreeFactory.getLeafs scope.namespace
                            rowRepeat = angular.element "<tr>"
                            # Este ng-repeat solo debe ir si no hay subQ
                            if subQuestion is false
                                rowRepeat.attr("ng-repeat",
                                    "ans in answersObject.values")
                            rowRepeat.addClass "sectir-ans-row"

                            #Aquí empezamos a poner valores
                            leafsByPre = sectirTreeFactory.
                                getLeafs scope.namespace, "pre"
                            insertHeaders = ->
                                if subQuestion
                                    headerSubQ = angular.element "<th>"
                                    headerSubQ.text subQuestion[scope.subqenun]
                                    headerSubQ.addClass "sectir-table-subq"
                                    rowRepeat.append headerSubQ
                                for l in leafsByPre
                                    headerRepeat = angular.element "<th>"
                                    headerRepeat.addClass "sectir-answer"
                                    if not haveSubQuestions
                                        rowModel = ngModelRow l.model.id
                                    else
                                        rowModel = ngModelRow(l.model.id,
                                            subQuestion.id)
                                    typefieldDefined = angular.isDefined(
                                        l.model[scope.typefield]
                                    )
                                    if typefieldDefined
                                        switch l.model[scope.typefield]
                                            when "select"
                                                input = angular.element(
                                                    "<select>")
                                            when "tag-input", "tags-input"
                                                input = angular.element(
                                                    "<tags-input>")
                                            else
                                                input = angular.element(
                                                    "<input>")
                                    else
                                        input = angular.element("<input>")
                                    input.attr "ng-model", rowModel
                                    if typefieldDefined
                                        input.attr "type",\
                                        l.model[scope.typefield]
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
                                return
                            insertHeaders()
                            if not haveSubQuestions
                                deleteButton = angular.element "<th>"
                                deleteButton.addClass "sectir-button-delete"
                                spanDelete = angular.element "<span>"
                                spanDelete.attr("ng-click",
                                    "deleteAnswer($index)")
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
                        if not haveSubQuestions
                            templateAnswers = templateAnswersFn()
                            table.append templateAnswers
                        else
                            for subQ in scope.subquestions
                                templateAnswers = templateAnswersFn subQ
                                table.append templateAnswers
                        $compile(table)(scope)

                        element.append table
                        if not haveSubQuestions
                            scope.addAnswer()
                    watchFn = ->
                        [
                            scope.namespace
                            scope.tabledata
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
