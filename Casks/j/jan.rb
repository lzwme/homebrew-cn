cask "jan" do
  arch arm: "arm64", intel: "x64"

  version "0.5.6"
  sha256 arm:   "a4aaf93ed9722eb569d096ff71e78ab6626de955290d89f67c29bc17d7e833b5",
         intel: "ae489d31da96bfa49386beca57ad1a2e9e89e3e4a324ccb5878ba34000ddb377"

  url "https:github.comjanhqjanreleasesdownloadv#{version}jan-mac-#{arch}-#{version}.dmg",
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