cask "acreom" do
  arch arm: "-arm64"

  version "1.15.15"
  sha256 arm:   "90a218ef1f6003fb7ad2b27760b355fae402056cec3482e312617e06e9c64c1d",
         intel: "09e87022ed16336adaeaf695cd89d18d49383382a56ec5b363a1fbcfc5abd3a5"

  url "https:github.comAcreomreleasesreleasesdownloadv#{version}acreom-#{version}#{arch}.dmg",
      verified: "github.comAcreomreleases"
  name "acreom"
  desc "Personal knowledge base for developers"
  homepage "https:acreom.com"

  depends_on macos: ">= :high_sierra"

  app "acreom.app"

  zap trash: [
    "~LibraryApplication Supportacreom",
    "~LibraryLogsacreom",
    "~LibraryPreferencescom.acreom.acreom-desktop.plist",
    "~LibrarySaved Application Statecom.acreom.acreom-desktop.savedState",
  ]
end