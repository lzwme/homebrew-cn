cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.19"
  sha256 arm:   "a566e293b3d77093f81f1ff466daf105192396dde0e5be610cf799e85230731a",
         intel: "a02c1d218d2fbb5091f46a969241b4af718cf79d859d18755f833307b5b40c78"

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