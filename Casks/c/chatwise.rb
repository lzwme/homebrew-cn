cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.57"
  sha256 arm:   "e971e4a2d64cef370a7e7f7899ab3e75f66a95b5615fac131aa3e3bd859e3e84",
         intel: "41163c541243631302aa341b6b14771e2e73ca3e1a77482b988d07e3cb2756d2"

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