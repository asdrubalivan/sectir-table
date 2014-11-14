angular.module 'sectirTableModule.dataFactory', []
    .factory 'sectirDataFactory', ->
        new class SectirDataFactory
            constructor: ->
                @data = {}
            saveData: (data, namespace="default") ->
                @data[namespace] = data
            getData: (namespace="default") ->
                @data[namespace]
