cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.90.6"
  sha256 arm:   "8da0421bb3d96fc8853ad4e4621efeeabb07db436720c941a396bb38017db10d",
         intel: "a860cc737cc12ed61b6f569605b91206ae76a5607bad1390583cb28b93bd4556"

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