cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.14"
  sha256 arm:   "f4bafc09acc76f045eed726389a160d3091fed00661ebccd729102525c265ec2",
         intel: "f540ecd17c2bb372ad16abd59e0d1f228568d19caa635cb5e80fdcacb674ec5f"

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