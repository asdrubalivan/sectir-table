angular.module('sectirTableModule.table', ['sectirTableModule.treeFactory'])
    .directive 'sectirTable', [
        "sectirTreeFactory",
        (sectirTreeFactory) ->
            {
                restrict: "EA"
                scope:
                    namespace: "="
                    tabledata: "="
                    titleField: "="
                link: (scope, element, attrs, ctrl) ->
                    scope.namespace = if scope.namespace
                            scope.namespace
                        else
                            "default"
                    sectirTreeFactory.addTree scope.tabledata, scope.namespace
                    rows = sectirTreeFactory.getRows scope.namespace
                    titleField = if scope.titleField
                            scope.titleField
                        else
                            "name"
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
                            elm.attr "rowspan",
                                (sectirTreeFactory.
                                    getNodeLevelsFromMax(field.model.id,
                                        scope.namespace) + 1)
                            headers.push elm
                        if firstRow
                            firstRow = false
                            elm = angular.element "<th>"
                            elm.addClass "sectir-delete"
                            elm.attr "colspan", 1
                            elm.attr "rowspan", sectirTreeFactory.
                                getTreeHeight scope.namespace
                            headers.push elm
                        for val in headers
                            tr.append val
                        trRows.push tr
                    for val in trRows
                        table.append val
                    element.append table
            }
    ]
