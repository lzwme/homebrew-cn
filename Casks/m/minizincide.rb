cask "minizincide" do
  version "2.9.1"
  sha256 "735b58edb33515cbd7c96ad25c2e07c1c29e0b6086df52b754f582d5c5bfae8d"

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