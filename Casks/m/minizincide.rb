cask "minizincide" do
  version "2.8.6"
  sha256 "f7f55bdc3b95f12b3405b43448295675ca613a9ade931e3a16cf5c727b2f976e"

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