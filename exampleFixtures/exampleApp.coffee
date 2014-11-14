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

tree2 =
    id: 1
    name: "Header"
    children:
        [
            {
                id: 2
                name: "Checkbox"
                type: "checkbox"
            }
            {
                id: "3-1"
                name: "List"
                type: "select"
                options:
                    "ng-options": "o for o in [1, 3, 5, 7]"
            }
            {
                id: 4
                name: "Father of email"
                children:
                    [
                        {
                            id: 5
                            name: "Email"
                            type: "email"
                        }
                    ]
            }
        ]

treeWithSelect =
    id: 1
    name: "Select"
    type: "select"
    options:
        "ng-options": "o for o in [2, 3, 5]"

inputVars =
    {
        "input1":
            [
                {
                    id: "1"
                    name: "Seleccioname"
                    type: "select"
                    options:
                        "ng-options": "o for o in [4, 5, 9]"
                    
                }
                {
                    id: "2"
                    name: "Un email"
                    type: "email"
                }
            ]
    }


angular.module 'ExampleApp', ['sectirTableModule']
    .controller "ExampleCtrl", [
        "$scope","$interval",
        "sectirDataFactory", ($scope, $interval, sdf) ->
            $scope.ctrlVars = {}
            $scope.ctrlVars.trees = {
                namespace1: tree1
                namespace2: tree2
                namespace3: treeWithSelect
            }
            $scope.ctrlVars.inputs = inputVars
            $scope.ctrlVars.label = "My Label"
            $scope.ctrlVars.debug = true
            $scope.dataVars = 0
            $interval(
                ->
                    $scope.dataVars = sdf.data
                , 1000
            )
    ]
