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
                        'test/**/*.coffee', 'exampleFixtures/**/*.coffee']
                options:
                    configFile: 'coffeelint.json'
            
        bower_concat:
            all:
                dest: "build/bower.js"
        coffee:
            compile:
                files:
                    "build/script.js": ["module/**/*.coffee"]
                    "build/example.js": ["exampleFixtures/**/*.coffee"]
        'http-server':
            all:
                root: "./"
        copy:
            main:
                src: "build/script.js"
                dest: "dist/sectir_module.js"
        watch:
            all:
                files: [
                    'module/**/*.coffee'
                    'exampleFixtures/**/*.coffee'
                ]
                tasks: ['serve']
                options:
                    livereload: true
                
                
    grunt.loadNpmTasks 'grunt-karma'
    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-bower-concat'
    grunt.loadNpmTasks 'grunt-http-server'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-copy'

    grunt.registerTask 'default', ['coffeelint','karma', "coffee", "copy:main"]
    grunt.registerTask 'serve', ["default", "bower_concat", "http-server"]
