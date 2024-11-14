cask "jan" do
  arch arm: "arm64", intel: "x64"

  version "0.5.8"
  sha256 arm:   "37c0bbb11af61c9055a126828674a259f3c47dd1e3fc8672c8c5a515ab685938",
         intel: "d5bf3f872ae0650986ba03590891a44b545c38fc0d95d50bb6c895ee3d6d1360"

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