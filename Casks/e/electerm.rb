cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.90.8"
  sha256 arm:   "c1b7efbfb15428959941b84b58201f0a88ceed8c390cf37507d35d30a6db71ce",
         intel: "79ac6188be96511ca3766691a697d2d84da18fe16a8ec99d70e2e469e8d45552"

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