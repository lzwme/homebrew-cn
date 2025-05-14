cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.52"
  sha256 arm:   "00fbae9c1e52f0cab25cee810e9ddd791f05a4c1bba9e203132c186c4d3274b7",
         intel: "28e8fe5b7d3c1d94a3315667a1c7a5a97896bd24eff1b85d5f32c5b82d4598a7"

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