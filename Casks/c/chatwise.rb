cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.21"
  sha256 arm:   "4b8ac105eca5bb0649bbc5f913b9f59c547324c417348bb398586a9874ae9954",
         intel: "28f846256744874ba2d54824239d7ffd9d6650733f91ad7c1292a31cffbb7f44"

  url "https:github.comegoistchatwise-releasesreleasesdownloadv#{version}ChatWise_#{version}_#{arch}.dmg",
      verified: "github.comegoistchatwise-releases"
  name "ChatWise"
  desc "AI chatbot for many LLMs"
  homepage "https:chatwise.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "ChatWise.app"

  uninstall quit: "app.chatwise"

  zap trash: [
    "~LibraryApplication Supportapp.chatwise",
    "~LibraryCachesapp.chatwise",
    "~LibrarySaved Application Stateapp.chatwise.savedState",
    "~LibraryWebKitapp.chatwise",
  ]
end