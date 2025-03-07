cask "minizincide" do
  version "2.9.2"
  sha256 "f658dff871773a22c91c5f3ca156c62abd1d2fbb698b59cdc411630ffcbfbf91"

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