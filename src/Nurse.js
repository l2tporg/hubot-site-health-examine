// Generated by CoffeeScript 1.10.0
var _ = require('lodash');

var Nurse = (function() {
    function Nurse(robot) {
      console.log("Nurse: I'll go get patients.");
      this.robot = robot;
      this.brainKey = 'sites';
    }

    Nurse.prototype.getList = function() {
      var list, ref;
      list = (ref = this.robot.brain.get(this.brainKey)) !== null ? ref : [];
      return list;
    };


    /* Remove */
    Nurse.prototype.removeSite = function(index) {
      var list, tmp;
      list = this.getList();

      /* エラーチェック(範囲外判定) */
      if (index > (_.size(list) - 1)) {
        return false;
      }

      /* 最後の出力に使う */
      tmp = {
        url: list[index].url,
        status: list[index].status
      };

      /* indexから1つ削除 */
      list.splice(index, 1);
      return tmp;
    };


    /* Update */
    Nurse.prototype.updateSite = function(index, newStatus) {
      var list;
      list = this.getList();
      if (index > (_.size(list) - 1)) {
        return false;
      }
      list[index].status = newStatus;
      return true;
    };

    /* index生成 */
    Nurse.prototype.searchIndex = function(obj, key) {
      var index, newObj;
      newObj = _.map(obj, 'url');
      index = newObj.indexOf(key);
      if (index > -1) {
        return index;
      } else {
        return false;
      }
    };

    Nurse.prototype.checkConfliction = function(obj, key) {
      if (_.findIndex(obj, {
        url: key
      }) > -1) {
        return false;
      } else {
        return true;
      }
    };

    return Nurse;
  })();

module.exports.Nurse = Nurse;
