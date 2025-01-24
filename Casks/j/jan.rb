cask "jan" do
  version "0.5.14"
  sha256 "ff00c64ec655da58921ebc9bbe74b6d1ff71377bf63f11e2d86d59b3ff865951"

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