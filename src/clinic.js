// Generated by CoffeeScript 1.10.0
var Nurse = require('./Nurse').Nurse;
var Doctor = require('./Doctor').Doctor;
var request = require('request');
var async = require('async');


module.exports = function(robot) {
  /* 自発的なサイトチェック */
  /* healthExamineイベント方式 */
  robot.hear(/she examine with event/i, function(msg) {
    var list, nurse;
    nurse = new Nurse(robot);
    /* 出力内容の選定 */
    /* ###1st: error, 2nd: success, 3rd: fault */
    var flags = [1,1,1];
    list = nurse.getList();
    robot.emit('healthExamine', list, flags, msg);
  });
  
  /* Doctor方式 */
  robot.hear(/she examine with doctor/i, function(msg) {
    var list, nurse, doctor;
    doctor = new Doctor();
    nurse = new Nurse(robot);
    list = nurse.getList();
    //監視対象リストとcallback関数とmsgを渡す。
    doctor.examine(list, examineCallback, msg);
  });
  /* examine終了後のcallback */
  var examineCallback = function(message, msg) {
    var results = [];
    if (message.status === "error") {
      results.push(msg.send(message.discription));
    } else if (message.status === "matched") {
      results.push(msg.send(message.discription));
    } else if (message.status === "unmatched") {
      results.push(msg.send(message.discription));
    } else {
      results.push(void 0);
    }
    return results;
  };

  /* Add nurse to check */
  robot.hear(/she[\s]+add[\s]+(\S+)[\s]+(\d+)$/i, function(msg) {
    var list, i, index, status, url, nurse;
    var key = 'sites';
    nurse = new Nurse(robot);
    list = nurse.getList();
    url = msg.match[1];
    status = Number(msg.match[2]);
    i = {
      url: url,
      status: status
    };
    if (nurse.checkConfliction(list, i.url)) {
      list.push(i);
      robot.brain.set(key, list); //@@!< keyがglobalの時も'sites'を参照するぞ
      index = nurse.searchIndex(list, i.url); //@@!
      return msg.send("added " + index + ": " + i.url + ", " + i.status);
    } else {
      return msg.send("Such url had already been registered.");
    }
  });

  /* Get List of nurse */
  robot.hear(/she[\s]+list$/i, function(msg) {
    var list, message, nurse;
    nurse = new Nurse(robot);
    list = nurse.getList();
    message = list.map(function(i) {
      return (nurse.searchIndex(list, i.url)) + ": " + i.url + " " + i.status;
    }).join('\n');
    if (message) {
      return msg.send(message);
    } else {
      return msg.send("empty");
    }
  });

  /* Update expected status code */
  robot.hear(/she[\s]+update[\s]+(\d+)[\s]+(\d+)$/i, function(msg) {
    var list, status, url, nurse;
    nurse = new Nurse(robot);
    list = nurse.getList();
    url = msg.match[1];
    status = Number(msg.match[2]);
    if (nurse.updateSite(url, status)) {
      return msg.send("updated " + list[msg.match[1]].url + ", " + list[msg.match[1]].status);
    } else {
      return msg.send("error: There are no such registered site.");
    }
  });

  /* Remove Url from list */
  return robot.hear(/she[\s]+remove[\s]+(\d+)$/i, function(msg) {
    var list, nurse;
    nurse = new Nurse(robot);
    list = nurse.removeSite(msg.match[1]);
    if (list !== false) {
      return msg.send("removed " + list.url + ", " + list.status);
    } else {
      return msg.send("error: There are no such registered site.");
    }
  });
};
