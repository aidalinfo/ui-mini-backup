// const { QuasarResolver } = require("unplugin-vue-components/resolvers");
import { QuasarResolver } from "unplugin-vue-components/resolvers";
const autoImportPlugin = [
  "unplugin-auto-import/vite",
  {
    imports: [
      "vue",
      {
        "boot/axios": [["api"]],
        quasar: [["useQuasar"], ["QIcon"]],
        "vue-router": [["useRouter"], ["useRoute"]],
      },
    ],
    dts: "src/auto-imports.d.ts",
  },
];

const componentsPlugin = [
  "unplugin-vue-components/vite",
  {
    resolvers: [QuasarResolver()],
    dts: true,
  },
];

export { autoImportPlugin, componentsPlugin };
