cask "jan" do
  version "0.6.4"
  sha256 "d6d3bc1d38bb37db98d5cdc9f6084d8e3dba54c1d63295cd22be98c24e7256ec"

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