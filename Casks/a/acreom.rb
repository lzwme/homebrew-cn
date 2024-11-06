cask "acreom" do
  arch arm: "-arm64"

  version "1.20.4"
  sha256 arm:   "91b673c58c1c531f3dd7c16d7a2c2f4a4bc7e5cde04e04fa54f54e50214e1233",
         intel: "b6236f94fad998b9fba7ac476967b8d29fd038fc44fb293e16b250cfc946c3e3"

  url "https:github.comAcreomappreleasesdownloadv#{version}acreom-#{version}#{arch}.dmg",
      verified: "github.comAcreomapp"
  name "acreom"
  desc "Personal knowledge base for developers"
  homepage "https:acreom.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "acreom.app"

  zap trash: [
    "~LibraryApplication Supportacreom",
    "~LibraryLogsacreom",
    "~LibraryPreferencescom.acreom.acreom-desktop.plist",
    "~LibrarySaved Application Statecom.acreom.acreom-desktop.savedState",
  ]
end