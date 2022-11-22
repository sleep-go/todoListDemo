// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList {
    struct todoList {
        string name;
        string date;
    }

    mapping(address => todoList[]) public userTodoList;

    event addSuccess(address);
    event deleteSuccess(address);

    function getUserTodoList() external view returns (todoList[] memory) {
        return userTodoList[msg.sender];
    }

    function addTodo(string memory _name, string memory _date) external {
        userTodoList[msg.sender].push(todoList({name : _name, date : _date}));
        emit addSuccess(msg.sender);
    }

    function deleteTodo(uint256 _x) external {
        require(userTodoList[msg.sender].length > _x, "out of index");
        for (uint256 i = _x; i < userTodoList[msg.sender].length - 1; i++) {
            userTodoList[msg.sender][i] = userTodoList[msg.sender][i + 1];
        }
        userTodoList[msg.sender].pop();
        emit deleteSuccess(msg.sender);
    }
}
