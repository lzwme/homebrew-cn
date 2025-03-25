cask "jan" do
  version "0.5.16"
  sha256 "0dee92a051db16471a1b91a91b54263d6c780865fa7bc9cd7ed46a9f141a1b82"

  url "https:github.comjanhqjanreleasesdownloadv#{version}jan-mac-universal-#{version}.dmg",
      verified: "github.comjanhqjan"
  name "Jan"
  desc "Offline AI chat tool"
  homepage "https:jan.ai"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Jan.app"

  zap trash: [
    "~LibraryApplication SupportJan",
    "~LibraryPreferencesjan.ai.app.plist",
    "~LibrarySaved Application Statejan.ai.app.savedState",
  ]
end