cask "syntax-highlight" do
  version "2.1.25"
  sha256 "bcb782afc31b7df1859c3414b52253baf50c07a26210b2c55d785a52914bacdd"

  url "https:github.comsbarexSourceCodeSyntaxHighlightreleasesdownload#{version}Syntax.Highlight.zip"
  name "Syntax Highlight"
  desc "Quicklook extension for source files"
  homepage "https:github.comsbarexSourceCodeSyntaxHighlight"

  # The Sparkle feed contains `pubDate` values that are in Italian (e.g.
  # mar, 31 dic 2024 18:21:00 +0100), so the `Sparkle` strategy doesn't
  # accurately sort the items by date. We have to work with all the feed items
  # in the `strategy` block, as a way of avoiding the sorting issues.
  livecheck do
    url "https:sbarex.github.ioSourceCodeSyntaxHighlightappcast.xml"
    strategy :sparkle do |items|
      items.map(&:short_version)
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Syntax Highlight.app"
  binary "#{appdir}Syntax Highlight.appContentsResourcessyntax_highlight_cli"

  zap trash: [
    "~LibraryApplication Scriptsorg.sbarex.SourceCodeSyntaxHighlight",
    "~LibraryApplication Scriptsorg.sbarex.SourceCodeSyntaxHighlight.QuicklookExtension",
    "~LibraryApplication SupportSyntax Highlight",
    "~LibraryCachescom.apple.helpdGeneratedorg.sbarex.SourceCodeSyntaxHighlight.help*",
    "~LibraryContainersorg.sbarex.SourceCodeSyntaxHighlight",
    "~LibraryContainersorg.sbarex.SourceCodeSyntaxHighlight.QuicklookExtension",
    "~LibraryPreferencesorg.sbarex.SourceCodeSyntaxHighlight.plist",
  ]
end