module.exports = (grunt) ->
    grunt.initConfig
        karma:
            unit:
                configFile: 'karma.conf.js'
                singleRun: yes
        coffeelint:
            all:
                files:
                    src: ['Gruntfile.coffee', 'module/**/*.coffee',
                        'test/**/*.coffee']
                options:
                    configFile: 'coffeelint.json'
        coffee:
            compile:
                files:
                    "build/script.js": ["module/**/*.coffee"]
                
    grunt.loadNpmTasks 'grunt-karma'
    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-coffee'

    grunt.registerTask 'default', ['coffeelint','karma', "coffee"]
