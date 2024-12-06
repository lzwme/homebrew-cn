cask "jan" do
  version "0.5.11"
  sha256 "6cdf556991e8eca749ad80d7d6cd64d33924cd574336c6913460baeb74dba2c1"

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