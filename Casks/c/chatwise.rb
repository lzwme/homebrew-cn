cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.27"
  sha256 arm:   "6aa48e67ba277f75d0dc0d3830c4903b50f075ca6367c7eadb897b22defccb77",
         intel: "5b12094aebb2ef934d41752b2b6c7fbfbe5b38879c46d946ff46ee88c644216f"

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