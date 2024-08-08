import { defineConfig } from "ao-deploy";

export default defineConfig({
  "voting-dapp": {
    name: "voting-dapp",
    contractPath: "src/contract.lua",
    luaPath: "./src/?.lua",
  },
});
