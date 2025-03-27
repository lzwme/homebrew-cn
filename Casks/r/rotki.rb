cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.38.2"
  sha256 arm:   "274075f574b07fa66e3e4bf422cd85a9effa7e2ec44c0cf726fa46a050ce3a55",
         intel: "9b7a5ea69ff32e315e69a23ad1b4bcb276ea8d9ad326d6a37b1b32219d1eabeb"

  url "https:github.comrotkirotkireleasesdownloadv#{version}rotki-darwin_#{arch}-v#{version}.dmg",
      verified: "github.comrotkirotki"
  name "Rotki"
  desc "Portfolio tracking and accounting tool"
  homepage "https:rotki.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "rotki.app"

  zap trash: [
    "~LibraryApplication Supportrotki",
    "~LibraryPreferencescom.rotki.app.plist",
    "~LibrarySaved Application Statecom.rotki.app.savedState",
  ]
end