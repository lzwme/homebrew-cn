cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.91.1"
  sha256 arm:   "50e99586e9dd0ad4765aa8793e36cda55bb12c79f825e7fb6907c057f2685f95",
         intel: "294c30da497a7fce01e6bb65538b83d6022382c1bc24feb8e6d542b440ba1d08"

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