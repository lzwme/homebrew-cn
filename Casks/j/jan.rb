cask "jan" do
  version "0.5.12"
  sha256 "b78e4ed2e00b181f6e785904456fd76dc205b4efa1a5cf72297a28c01850e820"

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