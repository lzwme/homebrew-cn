cask "minizincide" do
  version "2.8.7"
  sha256 "89f0b68f1bd72c32eb76377be46c3ec0f76f793b23de8ad876a16fbae37b79dc"

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