cask "jan" do
  version "0.5.13"
  sha256 "37e60ef4a1481ecf0ee4ea2863389493fda6c22b92fbfa86b14111efe781a3c5"

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