cask "qlmarkdown" do
  version "1.0.21"
  sha256 "bf669572403227410df0c19002c8a55d2c0cf6121c7fcb5ede26137e39449aad"

  url "https:github.comsbarexQLMarkdownreleasesdownload#{version}QLMarkdown.zip"
  name "sbarex QLMarkdown"
  desc "Quick Look generator for Markdown files"
  homepage "https:github.comsbarexQLMarkdown"

  livecheck do
    url "https:sbarex.github.ioQLMarkdownappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "QLMarkdown.app"
  binary "#{appdir}QLMarkdown.appContentsResourcesqlmarkdown_cli"

  zap trash: [
    "~LibraryApplication Scriptsorg.sbarex.QLMarkdown",
    "~LibraryApplication Scriptsorg.sbarex.QLMarkdown.QLExtension",
    "~LibraryContainersorg.sbarex.QLMarkdown",
    "~LibraryContainersorg.sbarex.QLMarkdown.QLExtension",
    "~LibraryGroup Containersorg.sbarex.qlmarkdown",
    "~LibraryPreferencesorg.sbarex.QLMarkdown.plist",
    "~LibraryQuickLookQLMarkdown.qlgenerator",
  ]
end