cask "qlmarkdown" do
  version "1.0.21"
  sha256 "bf669572403227410df0c19002c8a55d2c0cf6121c7fcb5ede26137e39449aad"

  url "https:github.comsbarexQLMarkdownreleasesdownload#{version}QLMarkdown.zip"
  name "sbarex QLMarkdown"
  desc "Quick Look generator for Markdown files"
  homepage "https:github.comsbarexQLMarkdown"

  # The Sparkle feed contains `pubDate` values that are in Italian (e.g.
  # mar, 31 dic 2024 18:36:00 +0100), so the `Sparkle` strategy doesn't
  # accurately sort the items by date. We have to work with all the feed items
  # in the `strategy` block, as a way of avoiding the sorting issues.
  livecheck do
    url "https:sbarex.github.ioQLMarkdownappcast.xml"
    strategy :sparkle do |items|
      items.map(&:short_version)
    end
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
    "~LibraryGroup Containersorg.sbarex.QLMarkdown",
    "~LibraryPreferencesorg.sbarex.QLMarkdown.plist",
    "~LibraryQuickLookQLMarkdown.qlgenerator",
  ]
end