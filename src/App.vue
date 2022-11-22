<template>
  <el-button @click="addTodo">添加</el-button>
  <el-table :data="tableData">
    <el-table-column prop="name" label="名称" />
    <el-table-column prop="date" label="时间" />
    <el-table-column label="操作">
      <template #default="scope">
        <el-button @click="deleteTodo(scope.$index)">删除</el-button>
      </template>
    </el-table-column>
  </el-table>

  <el-dialog v-model="dialogFormVisible" title="添加">
    <el-form :model="form">
      <el-form-item label="名称">
        <el-input v-model="form.name" autocomplete="off" />
      </el-form-item>
      <el-form-item label="时间">
        <el-date-picker
          v-model="form.date"
          type="datetime"
          placeholder="Select date and time"
        />
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogFormVisible = false"> 取消 </el-button>
        <el-button type="primary" @click="saveTodo"> 确定 </el-button>
      </span>
    </template>
  </el-dialog>
</template>
<script setup lang="ts">
import { onMounted, reactive, ref } from "vue";
import Web3 from "web3";

const tableData = ref([]);
const dialogFormVisible = ref(false);
const form = reactive({
  name: "",
  date: "",
});
const addTodo = () => {
  form.name = "";
  form.date = "";
  dialogFormVisible.value = true;
};
const saveTodo = async () => {
  let account = await web3.eth.getAccounts();
  let res = await contract.methods
    .addTodo(form.name, form.date.toString())
    .send({ from: account[0] });
  console.log(res);
  await getTableData();
  dialogFormVisible.value = false;
};
const deleteTodo = async (index: any) => {
  let account = await web3.eth.getAccounts();
  let res = await contract.methods.deleteTodo(index).send({ from: account[0] });
  await getTableData();
  dialogFormVisible.value = false;
};
const initWeb3 = () => {
  let web3Provider;
  if (window.ethereum) {
    web3Provider = window.ethereum;
    ethereum.on("accountsChanged", (accounts: string[]) => {
      console.log(accounts[0]); //一旦切换账号这里就会执行
      getTableData();
    });
    try {
      // 请求用户授权
      // window.ethereum.enable();
      ethereum.send("eth_requestAccounts");
    } catch (error) {
      // 用户不授权时
      console.error("User denied account access");
    }
  }
  return new Web3(web3Provider); //web3js就是你需要的web3实例

  // return new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
};
const web3 = initWeb3();

const contract = new web3.eth.Contract(
  [
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      name: "addSuccess",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      name: "deleteSuccess",
      type: "event",
    },
    {
      inputs: [
        {
          internalType: "string",
          name: "_name",
          type: "string",
        },
        {
          internalType: "string",
          name: "_date",
          type: "string",
        },
      ],
      name: "addTodo",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "_x",
          type: "uint256",
        },
      ],
      name: "deleteTodo",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "getUserTodoList",
      outputs: [
        {
          components: [
            {
              internalType: "string",
              name: "name",
              type: "string",
            },
            {
              internalType: "string",
              name: "date",
              type: "string",
            },
          ],
          internalType: "struct TodoList.todoList[]",
          name: "",
          type: "tuple[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      name: "userTodoList",
      outputs: [
        {
          internalType: "string",
          name: "name",
          type: "string",
        },
        {
          internalType: "string",
          name: "date",
          type: "string",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
  ],
  "0x22923DAD048BCAa037AcE2eD56DEd4724107f636"
);

onMounted(async () => {
  await getTableData();
});

const getTableData = async () => {
  let account = await web3.eth.getAccounts();
  console.log(account);
  tableData.value = await contract.methods
    .getUserTodoList()
    .call({ from: account[0] });
};
</script>
<style scoped></style>
