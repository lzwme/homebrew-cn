cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.55"
  sha256 arm:   "dc8661f3246db6510c2a1ec54e5337b96c118e254ac6e5221f40039fe75009b0",
         intel: "b85c45899964f7ed59cdffc7b62994d6d76cfa52d79970ef8f374e32665b6715"

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