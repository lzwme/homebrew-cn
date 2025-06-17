cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.65"
  sha256 arm:   "b4adf453c4e3b12cd1147245f739723dbcfefa52beebcaeb86761e4c4ced3544",
         intel: "43af4c98bfdeff0812061dfdd839cf4b8eb2290ddeaa372c79e19abbb2d553da"

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