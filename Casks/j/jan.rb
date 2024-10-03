cask "jan" do
  arch arm: "arm64", intel: "x64"

  version "0.5.5"
  sha256 arm:   "815ea80dd2a6e2ed21db7c32a15d080982b440fc0acf75eef9b291169c02093b",
         intel: "6021ed14d65c0d6e92708c03e8ff85cbe9573bc7b330f248a869a7363849d1ae"

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