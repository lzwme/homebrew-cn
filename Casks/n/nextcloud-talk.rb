cask "nextcloud-talk" do
  version "1.1.9"
  sha256 "72dd275f600939d31e5556e59e7118b89c55884f7590d471005ebb68baa97b93"

  url "https:github.comnextcloud-releasestalk-desktopreleasesdownloadv#{version}Nextcloud.Talk-macos-universal.dmg",
      verified: "github.comnextcloud-releasestalk-desktopreleasesdownload"
  name "Nextcloud Talk Desktop"
  desc "Official Nextcloud Talk Desktop client"
  homepage "https:nextcloud.comtalk"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Nextcloud Talk.app"

  zap trash: [
    "~LibraryApplication SupportNextcloud Talk",
    "~LibraryPreferencescom.nextcloud.talk.mac.plist",
  ]
end