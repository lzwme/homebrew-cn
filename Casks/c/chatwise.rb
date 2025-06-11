cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.63"
  sha256 arm:   "7f773022d23028872528e2a174e289d2c3641c4f504b968ec178f86e73c108de",
         intel: "83ab3d891ae15f9f4036f733fd69fdb248f33398058bc596a8347a47f5d88c16"

  url "https:github.comegoistchatwise-releasesreleasesdownloadv#{version}ChatWise_#{version}_#{arch}.dmg",
      verified: "github.comegoistchatwise-releases"
  name "ChatWise"
  desc "AI chatbot for many LLMs"
  homepage "https:chatwise.app"

  livecheck do
    url "https:chatwise.appapitrpcgetReleases"
    strategy :json do |json|
      json.dig("result", "data")&.map { |item| item["tag"]&.tr("v", "") }
    end
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