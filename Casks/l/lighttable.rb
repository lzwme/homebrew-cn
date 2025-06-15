cask "lighttable" do
  version "0.8.1"
  sha256 "423e9caf6db4dfe26a0167ea6ba998d747f233e2cd9cd97b7fee027c5c0c3992"

  url "https:github.comLightTableLightTablereleasesdownload#{version}lighttable-#{version}-mac.tar.gz",
      verified: "github.comLightTableLightTable"
  name "Light Table"
  desc "IDE"
  homepage "http:lighttable.com"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-01-06", because: :discontinued
  disable! date: "2025-01-07", because: :discontinued

  app "lighttable-#{version}-macLightTable.app"
  binary "lighttable-#{version}-maclight"

  zap trash: [
    "~LibraryApplication SupportLightTableplugins",
    "~LibraryApplication SupportLightTablesettings",
    "~LibraryPreferencescom.kodowa.LightTable.plist",
  ]
end