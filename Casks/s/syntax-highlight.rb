cask "syntax-highlight" do
  version "2.1.23"
  sha256 "ec46c01792c44bbdef1b2d99ef06c4fce6d2208f81db439cf04c22c8b5606887"

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
    "~LibraryCachescom.apple.helpdGeneratedorg.sbarex.SourceCodeSyntaxHighlight.help*#{version}",
    "~LibraryContainersorg.sbarex.SourceCodeSyntaxHighlight",
    "~LibraryContainersorg.sbarex.SourceCodeSyntaxHighlight.QuicklookExtension",
    "~LibraryPreferencesorg.sbarex.SourceCodeSyntaxHighlight.plist",
  ]
end