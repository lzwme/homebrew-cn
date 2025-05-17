cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.53"
  sha256 arm:   "f979496485a378e9ed21faa32e91762df08d4e9244c0ef5abd37f396710df091",
         intel: "9ab6b1da103a1c8b5edc73ef9e469f2b0caba6ad0bf1a408bc94352ad7e61210"

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