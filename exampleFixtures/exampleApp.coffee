tree1 =
    id: 1
    name: "Header"
    children:
        [
            {
                id: 2
                name: "Header 2"
                children:
                    [
                        {
                            id: 3
                            name: "Header 3"
                        }
                        {
                            id: 4
                            name: "Header 4"
                        }
                    ]
            }
            {
                id: 5
                name: "Header 5"
            }
        ]

angular.module 'ExampleApp', ['sectirTableModule']
    .controller "ExampleCtrl", ["$scope", ($scope) ->
        $scope.ctrlVars = {}
        $scope.ctrlVars.trees = {
            namespace1: tree1
        }
        $scope.ctrlVars.label = "My Label"
    ]
