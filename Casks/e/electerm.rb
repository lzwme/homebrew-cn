cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.91.8"
  sha256 arm:   "a5abf26c44b932a8a24dba6d658b587214bf0ed912b825b29b9322a970cab711",
         intel: "20bee7afc2cf44aed06b4b98b4524306a6f5b68f9170a31edbd7aca02ca0127e"

  url "https:github.comelectermelectermreleasesdownloadv#{version}electerm-#{version}-mac-#{arch}.dmg",
      verified: "github.comelectermelecterm"
  name "electerm"
  desc "Terminalsshsftp client"
  homepage "https:electerm.html5beta.com"

  livecheck do
    url "https:electerm.html5beta.comdataelecterm-github-release.json"
    strategy :json do |json|
      json.dig("release", "tag_name")&.sub("v", "")
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "electerm.app"
  binary "#{appdir}electerm.appContentsMacOSelecterm"

  zap trash: [
    "~LibraryApplication Supportelecterm",
    "~LibraryLogselecterm",
    "~LibraryPreferencesorg.electerm.electerm.plist",
    "~LibrarySaved Application Stateorg.electerm.electerm.savedState",
  ]
end