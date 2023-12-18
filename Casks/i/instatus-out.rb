cask "instatus-out" do
  version "1.0.8"
  sha256 "14ad0e0e13dd3b5747defccfd2483069297fedcd0d74727246d031bd23ab5649"

  url "https:github.cominstatushqoutreleasesdownloadv#{version}Instatus.Out-#{version}-mac.dmg",
      verified: "github.cominstatushqout"
  name "Instatus Out"
  desc "Monitor services in your menu bar"
  homepage "https:instatus.comout"

  app "Instatus Out.app"

  zap trash: [
    "~LibraryApplication Supportinstatus-out",
    "~LibraryPreferencescom.instatus.out.plist",
    "~LibrarySaved Application Statecom.instatus.out.savedState",
  ]
end