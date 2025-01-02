cask "syntax-highlight" do
  version "2.1.25"
  sha256 "bcb782afc31b7df1859c3414b52253baf50c07a26210b2c55d785a52914bacdd"

  url "https:github.comsbarexSourceCodeSyntaxHighlightreleasesdownload#{version}Syntax.Highlight.zip"
  name "Syntax Highlight"
  desc "Quicklook extension for source files"
  homepage "https:github.comsbarexSourceCodeSyntaxHighlight"

  livecheck do
    url "https:sbarex.github.ioSourceCodeSyntaxHighlightappcast.xml"
    strategy :sparkle, &:short_version
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