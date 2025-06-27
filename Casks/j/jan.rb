cask "jan" do
  version "0.6.3"
  sha256 "2a93f2f2b9f7da53fc4e213c8a18489af885f1a82cd2a4d5f5fd07e8e3702623"

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