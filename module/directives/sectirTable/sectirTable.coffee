angular.module('sectirTableModule.table', ['sectirTableModule.treeFactory'])
    .directive 'sectirTable', ->
        {
            restrict: "EA"
            scope:
                namespace: "@"
                tabledata: "="
            compile:
                (scope, element, attrs) ->
        }
