import React from "react";
import MDXContent from "@theme-original/MDXContent";
import type MDXContentType from "@theme/MDXContent";
import type { WrapperProps } from "@docusaurus/types";
import Admonition from "@theme/Admonition";

type Props = WrapperProps<typeof MDXContentType>;

export default function MDXContentWrapper(props: Props): JSX.Element {
  return (
    <>
      <Admonition type="info" title="Work in Progress">
        These docs are still a work-in-progress and may not be fully baked just
        yet! Please <a href="https://www.oskitone.com/contact">contact me</a> if
        any of it seems very wrong or needs extra clarification.
      </Admonition>
      <MDXContent {...props} />
    </>
  );
}
