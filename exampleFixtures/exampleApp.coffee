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
subQs =
    [
        {
            enunciado: "Mi enunciado 1"
            id: 1
        }
        {
            enunciado: "Mi segundo enunciado"
            id: 2
        }
        {
            enunciado: "Mi tercer enunciado"
            id: 3
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

sectirPagerInput =
    [
        {
            type: "input"
            namespace: "input"
            values:
                [
                    {
                        id: "1"
                        name: "My select"
                        type: "select"
                        options:
                            "ng-options": "x for x in [1, 2, 3, 5]"
                    }
                    {
                        id: "2"
                        name: "An email"
                        type: "email"
                    }
                ]
        }
        {
            type: "groupinput"
            namespace: "groupinput"
            values:
                [
                    {
                        id: "1"
                        name: "My select"
                        type: "select"
                        options:
                            "ng-options": "x for x in [1, 2, 3, 5]"
                    }
                    {
                        id: "2"
                        name: "An email"
                        type: "second email"
                    }
               ]
            
        }
        {
            type: "table"
            namespace: "table"
            values:
                {
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
                }
        }
    ]

exampleClick = ->
    alert "Me clickearon"

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
            #Voy a copiar lo que hay en inputVars["input1"]
            $scope.ctrlVars.grouptableinputs = {}
            $scope.ctrlVars.grouptableinputs["groupinput"] =
                angular.copy $scope.ctrlVars.inputs["input1"]
            $scope.ctrlVars.label = "My Label"
            $scope.ctrlVars.debug = true
            $scope.dataVars = 0
            $interval(
                ->
                    $scope.dataVars = sdf.data
                , 1000
            )
            $scope.ctrlVars.pagerInput = sectirPagerInput
            $scope.ctrlVars.clickFunc = exampleClick
            $scope.ctrlVars.subQs = subQs
            $scope.ctrlVars.namespaceSub = "subQs"
    ]
