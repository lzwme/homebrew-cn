cask "acreom" do
  arch arm: "-arm64"

  version "1.18.0"
  sha256 arm:   "744270db10812c5f57fb7d863b2da05b1065f074937e4d10106109115b87dc7d",
         intel: "24f46523bc9e8c73f8ad3edced79ed7822afe65320a120304c8060544320e10e"

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