cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.11"
  sha256 arm:   "c98258007dad4412424efdeb0630555b89eaae018326f38361c3c6d396b8bc71",
         intel: "1ea56b431cc067ad2011ea8526c69364e7e332f04cc0f9f3ae2ae86fb7a38b6d"

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