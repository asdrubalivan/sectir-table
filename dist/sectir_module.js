(function() {
  angular.module('sectirTableModule.groupinput', ['sectirTableModule.dataFactory']).directive('sectirGroupInput', [
    "sectirDataFactory", "$compile", function(sectirDataFactory, $compile) {
      var defaultValues;
      defaultValues = {
        namespace: "default",
        debugmodel: false,
        typefield: "type",
        namefield: "name",
        optionsfield: "options"
      };
      return {
        restrict: "EA",
        scope: {
          namespace: "=?",
          tabledata: "=",
          namefield: "=?",
          typefield: "=?",
          debugmodel: "=?",
          optionsfield: "=?",
          scopedata: "="
        },
        link: function(scope, element, attrs, ctrl) {
          var linkFn;
          scope.answersObject = {};
          linkFn = function() {
            var cellWithInput, currObjName, elm, elmDebug, elmName, elmWrapper, key, type, val, value, wrapTable, _i, _len, _ref, _ref1;
            for (key in defaultValues) {
              value = defaultValues[key];
              if (!angular.isDefined(scope[key])) {
                scope[key] = value;
              }
            }
            wrapTable = angular.element("<table>");
            wrapTable.addClass("sectir-groupinput-main");
            _ref = scope.scopedata;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              val = _ref[_i];
              currObjName = "answersObject['" + val.id + "']";
              elmWrapper = angular.element("<tr>");
              elmWrapper.addClass("sectir-groupinput-wrapper");
              elmName = angular.element("<td>");
              elmName.addClass("sectir-groupinput-namefield");
              elmName.text(val[scope.namefield]);
              type = val[scope.typefield] === "select" ? "select" : "input";
              elm = angular.element("<" + type + ">");
              if (type === "input") {
                elm.attr("type", val[scope.typefield]);
              }
              elm.attr("ng-model", currObjName);
              if (angular.isDefined(val[scope.optionsfield])) {
                _ref1 = val[scope.optionsfield];
                for (key in _ref1) {
                  value = _ref1[key];
                  elm.attr(key, value);
                }
              }
              elmWrapper.append(elmName);
              cellWithInput = angular.element("<td>");
              cellWithInput.addClass("sectir-groupinput-cell");
              cellWithInput.append(elm);
              elmWrapper.append(cellWithInput);
              if (scope.debugmodel) {
                elmDebug = angular.element("<td>");
                elmDebug.text("{{" + currObjName + "}}");
                elmWrapper.append(elmDebug);
              }
              wrapTable.append(elmWrapper);
            }
            $compile(wrapTable)(scope);
            element.append(wrapTable);
          };
          linkFn();
          return scope.$watch("answersObject", function() {
            console.log("Guardando datos");
            return sectirDataFactory.saveData(scope.answersObject, scope.namespace);
          }, true);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('sectirTableModule.input', ['sectirTableModule.dataFactory']).directive('sectirInput', [
    "sectirDataFactory", "$compile", function(sectirDataFactory, $compile) {
      var defaultValues;
      defaultValues = {
        namespace: "default",
        debugmodel: false,
        typefield: "type",
        namefield: "name",
        optionsfield: "options"
      };
      return {
        restrict: "EA",
        scope: {
          namespace: "=?",
          typefield: "=?",
          debugmodel: "=?",
          namefield: "=?",
          optionsfield: "=?",
          scopedata: "="
        },
        link: function(scope, element, attrs, ctrl) {
          var linkFn, watchFn;
          linkFn = function() {
            var currObjectName, divInput, elm, elmDebug, elmName, elmWrapper, key, type, val, value, wrapDiv, _i, _len, _ref, _ref1;
            for (key in defaultValues) {
              value = defaultValues[key];
              if (!angular.isDefined(scope[key])) {
                scope[key] = value;
              }
            }
            wrapDiv = angular.element("<div>");
            wrapDiv.addClass("sectir-input-main");
            _ref = scope.scopedata;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              val = _ref[_i];
              currObjectName = "answersObject['" + val.id + "']";
              elmWrapper = angular.element("<div>");
              elmWrapper.addClass("sectir-input-wrapper");
              elmName = angular.element("<div>");
              elmName.addClass("sectir-input-namefield");
              elmName.text(val[scope.namefield]);
              type = val[scope.typefield] === "select" ? "select" : "input";
              divInput = angular.element("<div>");
              divInput.addClass("sectir-input-input");
              elm = angular.element("<" + type + ">");
              if (type === "input") {
                elm.attr("type", val[scope.typefield]);
              }
              elm.attr("ng-model", currObjectName);
              divInput.append(elm);
              if (angular.isDefined(val[scope.optionsfield])) {
                _ref1 = val[scope.optionsfield];
                for (key in _ref1) {
                  value = _ref1[key];
                  elm.attr(key, value);
                }
              }
              elmWrapper.append(elmName);
              elmWrapper.append(divInput);
              if (scope.debugmodel) {
                elmDebug = angular.element("<div>");
                elmDebug.text("{{" + currObjectName + "}}");
                elmWrapper.append(elmDebug);
              }
              wrapDiv.append(elmWrapper);
            }
            scope.answersObject = {};
            $compile(wrapDiv)(scope);
            return element.append(wrapDiv);
          };
          watchFn = function() {
            return [scope.namespace, scope.scopedata];
          };
          linkFn();
          return scope.$watch("answersObject", function() {
            console.log("Guardando datos");
            return sectirDataFactory.saveData(scope.answersObject, scope.namespace);
          }, true);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('sectirTableModule.pager', ['sectirTableModule.dataFactory', 'sectirTableModule.input', 'sectirTableModule.table', 'sectirTableModule.groupinput']).directive('sectirPager', [
    "$compile", function($compile) {
      return {
        restrict: "EA",
        scope: {
          values: "=",
          settings: "=?",
          finalizefunc: "&"
        },
        controller: [
          "$scope", function($scope) {
            $scope.currPos = 0;
            $scope.nextButtonClick = function() {
              if ($scope.isNextButtonClickable()) {
                $scope.currPos++;
              }
            };
            $scope.prevButtonClick = function() {
              if ($scope.isPrevButtonClickable()) {
                --$scope.currPos;
              }
            };
            $scope.isPrevButtonClickable = function() {
              return $scope.currPos > 0;
            };
            $scope.isNextButtonClickable = function() {
              return $scope.currPos < ($scope.values.length - 1);
            };
            $scope.isFinalizeButtonClickable = function() {
              return $scope.finalizefunc && $scope.currPos === ($scope.values.length - 1);
            };
            $scope.nextButtonText = "Siguiente";
            $scope.prevButtonText = "Anterior";
            return $scope.finalizeButtonText = "Finalizar";
          }
        ],
        link: function(scope, element, attrs, ctrl) {
          var buttonDivRow, buttonFinal, buttonNext, buttonPrev, directive, divContainer, divWholeContainer, i, isSettingsDefined, key, myValues, t, val, valueVariable, _i, _j, _len, _len1, _ref;
          myValues = angular.copy(scope.values);
          divWholeContainer = angular.element("<div>");
          divWholeContainer.addClass("sectir-pager-wholecontainer");
          isSettingsDefined = {};
          isSettingsDefined["all"] = angular.isDefined(scope.settings);
          _ref = ["input", "table", "groupinput"];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            t = _ref[_i];
            isSettingsDefined[t] = isSettingsDefined["all"] && angular.isDefined(scope.settings[t]);
          }
          for (i = _j = 0, _len1 = myValues.length; _j < _len1; i = ++_j) {
            val = myValues[i];
            divContainer = angular.element("<div>");
            divContainer.addClass("sectir-pager-container");
            switch (val.type) {
              case "input":
                directive = angular.element("<sectir-input>");
                break;
              case "table":
                directive = angular.element("<sectir-table>");
                break;
              case "groupinput":
                directive = angular.element("<sectir-group-input>");
                break;
              default:
                throw new Error('Type must be input, table\nor group-input');
            }
            if (isSettingsDefined[val.type]) {
              for (key in scope.settings[val.type]) {
                directive.attr(key, "settings." + val.type + "." + key);
              }
            }
            valueVariable = (function() {
              switch (val.type) {
                case "input":
                case "groupinput":
                  return "scopedata";
                case "table":
                  return "tabledata";
                default:
                  return "";
              }
            })();
            directive.attr(valueVariable, "values[" + i + "].values");
            directive.attr("namespace", "values[" + i + "].namespace");
            divContainer.attr("ng-show", "currPos === " + i);
            divContainer.append(directive);
            divWholeContainer.append(divContainer);
          }
          buttonDivRow = angular.element("<div>");
          buttonDivRow.addClass("sectir-pager-button-row");
          buttonPrev = angular.element("<button>");
          buttonPrev.addClass("sectir-pager-prev-button");
          buttonPrev.text("{{ prevButtonText }}");
          buttonPrev.attr("ng-click", "prevButtonClick()");
          buttonPrev.attr("ng-disabled", "!isPrevButtonClickable()");
          buttonNext = angular.element("<button>");
          buttonNext.addClass("sectir-pager-next-button");
          buttonNext.text("{{ nextButtonText }}");
          buttonNext.attr("ng-click", "nextButtonClick()");
          buttonNext.attr("ng-disabled", "!isNextButtonClickable()");
          buttonFinal = angular.element("<button>");
          buttonFinal.addClass("sectir-pager-final-button");
          buttonFinal.text("{{ finalizeButtonText }}");
          buttonFinal.attr("ng-click", "finalizefunc()");
          buttonFinal.attr("ng-disabled", "!isFinalizeButtonClickable()");
          buttonDivRow.append(buttonPrev);
          buttonDivRow.append(buttonNext);
          buttonDivRow.append(buttonFinal);
          divWholeContainer.append(buttonDivRow);
          $compile(divWholeContainer)(scope);
          return element.append(divWholeContainer);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('sectirTableModule.table', ['sectirTableModule.treeFactory', 'sectirTableModule.dataFactory']).directive('sectirTable', [
    "sectirTreeFactory", "sectirDataFactory", "$compile", function(sectirTreeFactory, sectirDataFactory, $compile) {
      var defaultValues;
      defaultValues = {
        namespace: "default",
        deletefieldlabel: "Delete",
        debugmodel: false,
        deletelabel: "Delete",
        typefield: "type",
        titlefield: "name",
        optionsfield: "options",
        addlabel: "Add",
        addfieldlabel: "Add"
      };
      return {
        restrict: "EA",
        scope: {
          namespace: "=?",
          tabledata: "=",
          titlefield: "=?",
          deletelabel: "=?",
          deletefieldlabel: "=?",
          addfieldlabel: "=?",
          addlabel: "=?",
          typefield: "=?",
          debugmodel: "=?",
          optionsfield: "=?"
        },
        controller: [
          "$scope", function($scope) {
            return this.getLeafs = function() {
              sectirTreeFactory.getLeafs;
              return $scope.namespace;
            };
          }
        ],
        link: function(scope, element, attrs, ctrl) {
          var linkFn, watchFn;
          linkFn = function() {
            var elm, elmAdd, elmAnswers, field, firstRow, headers, key, remainingTable, row, rows, rowspan, spanAddLabel, spanDeleteLabel, table, templateAnswers, tr, trRows, treeHeight, val, value, _i, _j, _k, _l, _len, _len1, _len2, _len3;
            for (key in defaultValues) {
              value = defaultValues[key];
              if (!angular.isDefined(scope[key])) {
                scope[key] = value;
              }
            }
            sectirTreeFactory.addTree(scope.tabledata, scope.namespace);
            rows = sectirTreeFactory.getRows(scope.namespace);
            remainingTable = element.find("table");
            if (angular.isElement(remainingTable)) {
              remainingTable.remove();
            }
            table = angular.element("<table>");
            table.addClass("sectir-table");
            firstRow = true;
            trRows = [];
            for (_i = 0, _len = rows.length; _i < _len; _i++) {
              row = rows[_i];
              headers = [];
              tr = angular.element("<tr>");
              tr.addClass("sectir-table-header");
              for (_j = 0, _len1 = row.length; _j < _len1; _j++) {
                field = row[_j];
                elm = angular.element("<th>");
                elm.text(field.model[scope.titlefield]);
                elm.addClass("sectir-header");
                elm.attr("colspan", sectirTreeFactory.getNumberLeafsFromNode(field.model.id, scope.namespace));
                rowspan = (function() {
                  var hasChildren;
                  hasChildren = sectirTreeFactory.hasChildrenById(field.model.id, scope.namespace);
                  if (!hasChildren) {
                    return sectirTreeFactory.getNodeLevelsFromMax(field.model.id, scope.namespace) + 1;
                  } else {
                    return 1;
                  }
                })();
                elm.attr("rowspan", rowspan);
                headers.push(elm);
              }
              if (firstRow) {
                firstRow = false;
                treeHeight = sectirTreeFactory.getTreeHeight(scope.namespace);
                elm = angular.element("<th>");
                elm.addClass("sectir-delete");
                spanDeleteLabel = angular.element("<span>");
                spanDeleteLabel.text("{{ deletelabel }}");
                elm.append(spanDeleteLabel);
                elm.attr("colspan", 1);
                elm.attr("rowspan", treeHeight);
                elmAdd = angular.element("<th>");
                elmAdd.addClass("sectir-add");
                spanAddLabel = angular.element("<span>");
                spanAddLabel.text("{{ addlabel }}");
                elmAdd.append(spanAddLabel);
                elmAdd.attr("colspan", 1);
                elmAdd.attr("rowspan", treeHeight);
                headers.push(elmAdd);
                headers.push(elm);
              }
              for (_k = 0, _len2 = headers.length; _k < _len2; _k++) {
                val = headers[_k];
                tr.append(val);
              }
              trRows.push(tr);
            }
            for (_l = 0, _len3 = trRows.length; _l < _len3; _l++) {
              val = trRows[_l];
              table.append(val);
            }
            scope.answersObject = {};
            templateAnswers = (function() {
              var addButton, deleteButton, headerRepeat, iEl, index, input, l, leafs, leafsByPre, ngModelRow, options, rowModel, rowRepeat, spanAdd, spanDelete, typefieldDefined, _len4, _m;
              leafs = sectirTreeFactory.getLeafs(scope.namespace);
              rowRepeat = angular.element("<tr>");
              rowRepeat.attr("ng-repeat", "ans in answersObject.values");
              rowRepeat.addClass("sectir-ans-row");
              ngModelRow = function(modelId) {
                var temp;
                temp = "answersObject.values[$index]";
                temp += "['" + modelId + "']";
                return temp;
              };
              index = 0;
              leafsByPre = sectirTreeFactory.getLeafs(scope.namespace, "pre");
              for (_m = 0, _len4 = leafsByPre.length; _m < _len4; _m++) {
                l = leafsByPre[_m];
                headerRepeat = angular.element("<th>");
                headerRepeat.addClass("sectir-answer");
                rowModel = ngModelRow(l.model.id);
                typefieldDefined = angular.isDefined(l.model[scope.typefield]);
                if (typefieldDefined && l.model[scope.typefield] === "select") {
                  input = angular.element("<select>");
                } else {
                  input = angular.element("<input>");
                }
                input.attr("ng-model", rowModel);
                if (typefieldDefined) {
                  input.attr("type", l.model[scope.typefield]);
                }
                if (angular.isDefined) {
                  l.model[scope.optionsfield];
                  options = l.model[scope.optionsfield];
                  for (key in options) {
                    value = options[key];
                    input.attr(key, value);
                  }
                }
                if (scope.debugmodel) {
                  iEl = angular.element("<i>");
                  iEl.addClass("sectir-debug-model");
                  iEl.text("{{ " + rowModel + " }}");
                }
                headerRepeat.append(input);
                if (scope.debugmodel) {
                  headerRepeat.append(iEl);
                }
                rowRepeat.append(headerRepeat);
                index++;
              }
              deleteButton = angular.element("<th>");
              deleteButton.addClass("sectir-button-delete");
              spanDelete = angular.element("<span>");
              spanDelete.attr("ng-click", "deleteAnswer($index)");
              spanDelete.text("{{ deletefieldlabel }}");
              deleteButton.append(spanDelete);
              addButton = angular.element("<th>");
              addButton.addClass("sectir-button-add");
              spanAdd = angular.element("<span>");
              spanAdd.attr("ng-click", "addAnswer()");
              spanAdd.text("{{ addfieldlabel }}");
              addButton.append(spanAdd);
              rowRepeat.append(addButton);
              rowRepeat.append(deleteButton);
              return rowRepeat;
            })();
            elmAnswers = templateAnswers;
            table.append(elmAnswers);
            $compile(table)(scope);
            element.append(table);
            scope.answersObject.values = [];
            scope.addAnswer = function() {
              return scope.answersObject.values.push({});
            };
            scope.deleteAnswer = function(index) {
              scope.answersObject.values.splice(index, 1);
              if (scope.answersObject.values.length < 1) {
                return scope.addAnswer();
              }
            };
            return scope.addAnswer();
          };
          watchFn = function() {
            return [scope.namespace, scope.tabledata];
          };
          linkFn();
          scope.$watch(watchFn, linkFn, true);
          return scope.$watch("answersObject", function() {
            console.log("Guardando datos");
            return sectirDataFactory.saveData(scope.answersObject, scope.namespace);
          }, true);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('sectirTableModule.dataFactory', []).factory('sectirDataFactory', function() {
    var SectirDataFactory;
    return new (SectirDataFactory = (function() {
      function SectirDataFactory() {
        this.data = {};
      }

      SectirDataFactory.prototype.saveData = function(data, namespace) {
        if (namespace == null) {
          namespace = "default";
        }
        return this.data[namespace] = data;
      };

      SectirDataFactory.prototype.getData = function(namespace) {
        if (namespace == null) {
          namespace = "default";
        }
        return this.data[namespace];
      };

      return SectirDataFactory;

    })());
  });

}).call(this);

(function() {
  angular.module('sectirTableModule.treeFactory', []).factory('sectirTreeFactory', function() {
    var SectirTreeFactory;
    return new (SectirTreeFactory = (function() {
      function SectirTreeFactory() {
        this.trees = {};
        this.maxHeights = {};
        this.nodesById = {};
      }

      SectirTreeFactory.prototype.reset = function() {
        this.trees = {};
        this.maxHeights = {};
        return this.nodesById = {};
      };

      SectirTreeFactory.prototype.addTree = function(tree, namespace) {
        var treeM;
        if (namespace == null) {
          namespace = "default";
        }
        treeM = new TreeModel;
        this.trees[namespace] = treeM.parse(tree);
        this.maxHeights[namespace] = void 0;
        this.nodesById[namespace] = {};
      };

      SectirTreeFactory.prototype.getTreeHeight = function(namespace) {
        var retVal;
        if (namespace == null) {
          namespace = "default";
        }
        if (this.maxHeights[namespace] != null) {
          return this.maxHeights[namespace];
        }
        retVal = 0;
        this.trees[namespace].walk(function(node) {
          var level;
          level = node.getPath().length;
          if (level > retVal) {
            retVal = level;
          }
        });
        return this.maxHeights[namespace] = retVal;
      };

      SectirTreeFactory.prototype.getNodeHeightById = function(id, namespace) {
        var val;
        if (namespace == null) {
          namespace = "default";
        }
        val = this.getNodeById(id, namespace);
        if (val) {
          return val.getPath().length;
        } else {
          return false;
        }
      };

      SectirTreeFactory.prototype.getNodeById = function(id, namespace) {
        var retVal, _ref;
        if (namespace == null) {
          namespace = "default";
        }
        if (this.trees[namespace] == null) {
          return false;
        }
        if (this.nodesById[namespace][id] != null) {
          return this.nodesById[namespace][id];
        }
        id = String(id);
        retVal = false;
        if ((_ref = this.trees[namespace]) != null) {
          _ref.walk(function(node) {
            var modelId;
            modelId = String(node.model.id);
            if (modelId === id) {
              retVal = node;
              return false;
            }
          });
        }
        return this.nodesById[namespace][id] = retVal;
      };

      SectirTreeFactory.prototype.hasChildren = function(node) {
        return (node.children != null) && node.children.length > 0;
      };

      SectirTreeFactory.prototype.hasChildrenById = function(id, namespace) {
        if (namespace == null) {
          namespace = "default";
        }
        return this.hasChildren(this.getNodeById(id, namespace));
      };

      SectirTreeFactory.prototype.getLeafs = function(namespace, st) {
        var retVal, self, strategy;
        if (namespace == null) {
          namespace = "default";
        }
        if (st == null) {
          st = "breadth";
        }
        strategy = {
          strategy: st
        };
        self = this;
        retVal = this.trees[namespace] != null ? this.trees[namespace].all(strategy, function(node) {
          return !self.hasChildren(node);
        }) : false;
        return retVal;
      };

      SectirTreeFactory.prototype.getRows = function(namespace) {
        var curLevel, retVal, self, strategy;
        if (namespace == null) {
          namespace = "default";
        }
        strategy = {
          strategy: 'breadth'
        };
        retVal = [];
        curLevel = -1;
        self = this;
        this.trees[namespace].walk(strategy, function(node) {
          var nodeHeight;
          nodeHeight = self.getNodeHeightById(node.model.id, namespace);
          if (nodeHeight !== curLevel) {
            retVal.push([]);
            curLevel = nodeHeight;
          }
          retVal[curLevel - 1].push(node);
        });
        return retVal;
      };

      SectirTreeFactory.prototype.getNodeLevelsFromMax = function(id, namespace) {
        var node;
        if (namespace == null) {
          namespace = "default";
        }
        node = this.getNodeById(id, namespace);
        if (node === false) {
          return false;
        }
        return this.getTreeHeight(namespace) - node.getPath().length;
      };

      SectirTreeFactory.prototype.getNumberLeafsFromNode = function(id, namespace) {
        var node, retVal, self;
        if (namespace == null) {
          namespace = "default";
        }
        node = this.getNodeById(id, namespace);
        if (node === false) {
          return false;
        }
        retVal = 0;
        self = this;
        node.walk(function(aNode) {
          if (!self.hasChildren(aNode)) {
            retVal++;
          }
        });
        return retVal;
      };

      return SectirTreeFactory;

    })());
  });

}).call(this);

(function() {
  angular.module('sectirTableModule', ['sectirTableModule.table', 'sectirTableModule.input', 'sectirTableModule.groupinput', 'sectirTableModule.pager']);

}).call(this);
