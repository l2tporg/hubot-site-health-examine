// Generated by CoffeeScript 1.10.0
var Patients = require('./Patients');
var Doctor = require('./Doctor').Doctor;
var request = require('request');
var async = require('async');


module.exports = function(robot) {
  /* 自発的なサイトチェック */
  robot.hear(/she examine/i, function(msg) {
    var data, doctor, flag, j, key, len, message, obj, results, urls;
    console.log("examing...");
//    flag = msg.match[1];
    urls = new Patients(robot);
    data = urls.getData();
    doctor = new Doctor;
    message = {};
    results = [];
    for (key = j = 0, len = data.length; j < len; key = ++j) {
      obj = data[key];
      message = doctor.examineWithAsync({
        "url": obj.url,
        "status": obj.status
      });
      console.log(message);
      if (message.status === "error") {
        results.push(msg.send("" + message.discription));
      } else if (message.status === "matched") {
        results.push(msg.send("" + message.discription));
      } else if (message.status === "unmatched") {
        results.push(msg.send("" + message.discription));
      } else {
        results.push(void 0);
      }
    }
    return results;
  });

  /* Add Urls to check */
  robot.hear(/she[\s]+add[\s]+(\S+)[\s]+(\d+)$/i, function(msg) {
    var data, i, index, status, url, urls;
    var key = 'sites';
    urls = new Patients(robot);
    data = urls.getData();
    url = msg.match[1];
    status = Number(msg.match[2]);
    i = {
      url: url,
      status: status
    };
    if (urls.checkConfliction(data, i.url)) {
      data.push(i);
      robot.brain.set(key, data); //@@!< keyがglobalの時も'sites'を参照するぞ
      index = urls.searchIndex(data, i.url); //@@!
      return msg.send("added " + index + ": " + i.url + ", " + i.status);
    } else {
      return msg.send("Such url had already been registered.");
    }
  });

  /* Get List of Urls */
  robot.hear(/she[\s]+list$/i, function(msg) {
    var data, message, urls;
    urls = new Patients(robot);
    data = urls.getData();
    robot.logger.info(data); //@@
    message = data.map(function(i) {
      return (urls.searchIndex(data, i.url)) + ": " + i.url + " " + i.status;
    }).join('\n');
    if (message) {
      return msg.send(message);
    } else {
      return msg.send("empty");
    }
  });

  /* Update expected status code */
  robot.hear(/she[\s]+update[\s]+(\d+)[\s]+(\d+)$/i, function(msg) {
    var data, status, url, urls;
    urls = new Patients(robot);
    data = urls.getData();
    url = msg.match[1];
    status = Number(msg.match[2]);
    if (urls.updateSite(url, status)) {
      return msg.send("updated " + data[msg.match[1]].url + ", " + data[msg.match[1]].status);
    } else {
      return msg.send("error: There are no such registered site.");
    }
  });

  /* Remove Url from list */
  return robot.hear(/she[\s]+remove[\s]+(\d+)$/i, function(msg) {
    var data, urls;
    urls = new Patients(robot);
    data = urls.removeSite(msg.match[1]);
    if (data !== false) {
      return msg.send("removed " + data.url + ", " + data.status);
    } else {
      return msg.send("error: There are no such registered site.");
    }
  });
};