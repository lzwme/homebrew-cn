cask "syntax-highlight" do
  version "2.1.24"
  sha256 "31adcab045b69ad55eb0f47b4d0cb1c45f18dcf00e3391b8f32e15eeef7f97b9"

  url "https:github.comsbarexSourceCodeSyntaxHighlightreleasesdownload#{version}Syntax.Highlight.zip"
  name "Syntax Highlight"
  desc "Quicklook extension for source files"
  homepage "https:github.comsbarexSourceCodeSyntaxHighlight"

  auto_updates true
  depends_on macos: ">= :catalina"

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