import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: "Oskitone Space Dice Assembly Guide",
  tagline: "TODO",
  favicon: "img/favicon.ico",

  // Future flags, see https://docusaurus.io/docs/api/docusaurus-config#future
  future: {
    v4: true, // Improve compatibility with the upcoming Docusaurus v4
  },

  // Set the production url of your site here
  url: "https://oskitone.github.io",
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: "/space_dice/",

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: "oskitone",
  projectName: "space_dice",

  onBrokenLinks: "throw",

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      {
        docs: {
          routeBasePath: "/",
          sidebarPath: "./sidebars.ts",
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          // editUrl:
          //   "https://github.com/oskitone/space_dice/tree/main/assembly_guide/",
        },
        blog: false,
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: "img/TODO.gif",
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: "Oskitone Space Dice Assembly Guide",
    },
    announcementBar: {
      content: `These docs are brand new! Please <a href="https://www.oskitone.com/contact">contact me</a> if it any of it seems wrong or needs more clarification. Thanks!`,
      isCloseable: false,
    },
    footer: {
      style: "dark",
      copyright: `Copyright © ${new Date().getFullYear()} Oskitone. Built with Docusaurus.`,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
