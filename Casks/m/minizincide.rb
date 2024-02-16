cask "minizincide" do
  version "2.8.3"
  sha256 "88fdd9c57627480f4ac243b9389714f98c31eb5a08fe6d748324de94325b1bcc"

  url "https:github.comMiniZincMiniZincIDEreleasesdownload#{version}MiniZincIDE-#{version}-bundled.dmg",
      verified: "github.comMiniZincMiniZincIDE"
  name "MiniZincIDE"
  desc "Open-source constraint modelling language and IDE"
  homepage "https:www.minizinc.orgindex.html"

  conflicts_with formula: "minizinc"
  depends_on macos: ">= :sierra"

  app "MiniZincIDE.app"
  binary "#{appdir}MiniZincIDE.appContentsResourcesminizinc"
  binary "#{appdir}MiniZincIDE.appContentsResourcesmzn2doc"

  zap trash: [
    "~LibraryPreferencesorg.minizinc.MiniZinc IDE (bundled).plist",
    "~LibrarySaved Application Stateorg.minizinc.MiniZincIDE.savedState",
  ]
end