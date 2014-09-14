angular.module('sectirTableModule.table', [])
    .directive 'sectirTable', ->
        {
            restrict: "EA"
            scope:
                namespace: "@"
                tabledata: "="
            compile:
                (scope, element, attrs) ->
        }
