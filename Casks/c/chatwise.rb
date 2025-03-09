cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.25"
  sha256 arm:   "1a7cb74913e1c7137d27c0e205f1de5162c30af900f9c5670c339b5fc9b9d387",
         intel: "7441f51f1c27faab16464599e9e20480e6ace8ffca1b92c92dabc440f37a552d"

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