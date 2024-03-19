cask "acreom" do
  arch arm: "-arm64"

  version "1.17.0"
  sha256 arm:   "ce41b7396be543cff5f2918cd571ac081339f788f46b9421a09c3f24edd8ec96",
         intel: "abadd61ac2b843895c8788ad2a0e4cc6d3f2d01f882f2df28675d53524f7ee51"

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