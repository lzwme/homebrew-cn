cask "qlmarkdown" do
  version "1.0.17"
  sha256 "9f6265557db18fed69fd63a956557ccf0f4d980e323caa4a3957e247bb7a3926"

  url "https:github.comsbarexQLMarkdownreleasesdownload#{version}QLMarkdown.zip"
  name "sbarex QLMarkdown"
  desc "QuickLook generator for Markdown files"
  homepage "https:github.comsbarexQLMarkdown"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "QLMarkdown.app"

  zap trash: [
    "~LibraryApplication Scriptsorg.sbarex.QLMarkdown",
    "~LibraryApplication Scriptsorg.sbarex.QLMarkdown.QLExtension",
    "~LibraryContainersorg.sbarex.QLMarkdown",
    "~LibraryContainersorg.sbarex.QLMarkdown.QLExtension",
    "~LibraryPreferencesorg.sbarex.QLMarkdown.plist",
    "~LibraryQuickLookQLMarkdown.qlgenerator",
  ]
end