cask "jan" do
  version "0.6.1"
  sha256 "76fc25344e5c9d94d8279e3cf49bfb7ed94396f7c73ab8bbb3fa9c3858c1883d"

  url "https:github.comjanhqjanreleasesdownloadv#{version}jan-mac-universal-#{version}.zip",
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