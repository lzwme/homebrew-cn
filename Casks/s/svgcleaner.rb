cask "svgcleaner" do
  version "0.9.5"
  sha256 "d1f3098ad5008a8f727d53e764239844db063a0a9cc2aa21ac0b0bdef6011335"

  url "https:github.comRazrFalconsvgcleaner-guireleasesdownloadv#{version}svgcleaner_macos_#{version}.zip"
  name "SVG Cleaner"
  desc "Tool to clean up SVG files by removing unnecessary data"
  homepage "https:github.comRazrFalconsvgcleaner-gui"

  conflicts_with formula: "svgcleaner"

  app "SVGCleaner.app"
  binary "#{appdir}SVGCleaner.appContentsMacOSsvgcleaner-cli", target: "svgcleaner"

  zap trash: [
    "~LibraryPreferencescom.svgcleaner.svgcleaner.plist",
    "~LibrarySaved Application Statecom.yourcompany.SVGCleaner.savedState",
  ]

  caveats do
    discontinued
  end
end