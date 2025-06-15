cask "mater" do
  version "1.0.10"
  sha256 "613dba1cd8ca8dee74b30a456d3d2cb87896020b5305d6ff25f5f324499c4ee7"

  url "https:github.comjasonlongmaterreleasesdownload#{version}Mater-darwin-x64.zip"
  name "Mater"
  desc "Menubar pomodoro app"
  homepage "https:github.comjasonlongmater"

  no_autobump! because: :requires_manual_review

  app "Mater-darwin-x64Mater.app"

  zap trash: [
    "~LibraryApplication Supportmater",
    "~LibraryPreferencescom.electron.mater.plist",
    "~LibrarySaved Application Statecom.electron.mater.savedState",
  ]

  caveats do
    requires_rosetta
  end
end