cask "yaak@beta" do
  arch arm: "aarch64", intel: "x64"

  version "2025.2.0-beta.3"
  sha256 arm:   "5140d44886a075a5c98c441b940501b1bd8e9ebaa429fc7df7f86a9d6f64e2d4",
         intel: "fcdd1bb0c51d125c819347bff090d69b9c0d81beded6d8c2b253e52bc4d5a266"

  url "https:github.commountain-loopyaakreleasesdownloadv#{version}Yaak_#{version}_#{arch}.dmg",
      verified: "github.commountain-loopyaak"
  name "Yaak Beta"
  desc "REST, GraphQL and gRPC client"
  homepage "https:yaak.app"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+(?:[._-](?:beta|rc)[._-]\d+)?)$i)
  end

  auto_updates true
  conflicts_with cask: "yaak"
  depends_on macos: ">= :ventura"

  app "yaak.app"

  zap trash: [
    "~LibraryApplication Supportapp.yaak.desktop",
    "~LibraryCachesapp.yaak.desktop",
    "~LibraryLogsapp.yaak.desktop",
    "~LibrarySaved Application Stateapp.yaak.desktop.savedState",
    "~LibraryWebkitapp.yaak.desktop",
  ]
end