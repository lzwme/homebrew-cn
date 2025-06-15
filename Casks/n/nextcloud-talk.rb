cask "nextcloud-talk" do
  version "1.2.3"
  sha256 "c32d474a86163098efe08506e54da90b4d5f1bf2ea926239ebac771b720aad42"

  url "https:github.comnextcloud-releasestalk-desktopreleasesdownloadv#{version}Nextcloud.Talk-macos-universal.dmg",
      verified: "github.comnextcloud-releasestalk-desktopreleasesdownload"
  name "Nextcloud Talk Desktop"
  desc "Official Nextcloud Talk Desktop client"
  homepage "https:nextcloud.comtalk"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "Nextcloud Talk.app"

  zap trash: [
    "~LibraryApplication SupportNextcloud Talk",
    "~LibraryPreferencescom.nextcloud.talk.mac.plist",
  ]
end