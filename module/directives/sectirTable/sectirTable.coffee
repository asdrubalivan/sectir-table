angular.module('sectirTableModule.table', ['sectirTableModule.treeFactory'])
    .directive 'sectirTable', [
        "sectirTreeFactory"
        "$compile"
        (sectirTreeFactory, $compile) ->
            {
                restrict: "EA"
                scope:
                    namespace: "="
                    tabledata: "="
                    titleField: "="
                    deletelabel: "="
                controller: ["$scope", ($scope) ->
                    @getLeafs = ->
                        sectirTreeFactory.getLeafs
                        $scope.namespace
                ]
                link: (scope, element, attrs, ctrl) ->
                    linkFn = ->
                        scope.namespace = if scope.namespace
                                scope.namespace
                            else
                                "default"
                        sectirTreeFactory.addTree(scope.tabledata,
                            scope.namespace)
                        rows = sectirTreeFactory.getRows scope.namespace
                        titleField = if scope.titleField
                                scope.titleField
                            else
                                "name"
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
                                elm.text field.model[titleField]
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
                                elm = angular.element "<th>"
                                elm.addClass "sectir-delete"
                                elm.text "{{ deletelabel }}"
                                elm.attr "colspan", 1
                                elm.attr "rowspan", sectirTreeFactory.
                                    getTreeHeight scope.namespace
                                headers.push elm
                            for val in headers
                                tr.append val
                            trRows.push tr
                        for val in trRows
                            table.append val
                        scope.answersObject = {}
                        scope.answersObject.leafs =
                            sectirTreeFactory.getLeafs scope.namespace
                        templateAnswers = "
                            <tr ng-repeat='ans in answers'
                                class='sectir-ans-group'>

                                <th ng-repeat='q in answersObjectleafs'
                                    class='sectir-answer'>
                                   <input
                                   ng-model='answersObject.ans[#{titleField}]'
                                   >
                                   </input>
                                </th>
                                <th ng-click='deleteRow($index)'>
                                    X
                                </th>
                            </tr>
                        "
                        elmAnswers = angular.element templateAnswers
                        table.append elmAnswers
                        $compile(table)(scope)
                        element.append table
                    watchFn = ->
                        [
                            scope.namespace
                            scope.tabledata
                        ]
                    linkFn()

                    scope.$watch watchFn, linkFn, true
            }
    ]
