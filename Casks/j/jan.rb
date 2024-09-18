cask "jan" do
  arch arm: "arm64", intel: "x64"

  version "0.5.4"
  sha256 arm:   "4ec8942365a6cad8d422a3193ca1077b0a92922743ed318a2a04a8b5a316a343",
         intel: "8152b523d2ef92d1d2f355c8bbaa11a2a159bb464ce6ad5471795d77202263b5"

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