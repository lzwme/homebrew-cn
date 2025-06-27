cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.100.6"
  sha256 arm:   "7c739cf2653ed883ed5bf36c065c597f1a8a655be1ef438940ffb7c5a7a8286c",
         intel: "3643d2b293011aa8c699356f993b22ffe1c97f68cbc8d4c1c798e7bf37b75532"

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