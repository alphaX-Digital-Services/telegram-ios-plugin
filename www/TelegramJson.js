var exec = require('cordova/exec');

var PLUGIN_NAME = 'TelegramJson';

exports.create = function (arg1, arg2, arg3, success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'create', [arg1, arg2, arg3]);
};

exports.logout = function (success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'logout', [])
};

exports.getChats = function (arg1, arg2, arg3, success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'getChats', [arg1, arg2, arg3])
};

exports.getChatHistory = function (arg1, arg2, arg3, arg4, success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'getChatHistory', [arg1, arg2, arg3, arg4])
};

exports.getMe = function (success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'getMe', [])
};

exports.setUsername = function (arg1, success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'setUsername', [arg1])
};

exports.getNewMessages = function (success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'getNewMessages', [])
};

exports.getUserStatus = function (success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'getUserStatus', [])
};

exports.createPrivateChat = function (arg1, success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'createPrivateChat', [arg1])
};

exports.sendMessage = function(arg1, arg2, arg3, arg4, arg5, success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'sendMessage', [arg1, arg2, arg3, arg4, arg5])
};

exports.searchPublicChat = function (arg1, success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'searchPublicChat', [arg1])
};

exports.getAuthState = function (success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'getAuthState', [])
};

exports.sendPhoneNumber = function (arg1, success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'sendPhoneNumber', [arg1])
};

exports.sendCode = function (arg1, arg2, success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'sendCode', [arg1, arg2])
};

exports.resendCode = function (success, error) {
    exec(success, error, `${PLUGIN_NAME}`, 'resendCode', [])
};
