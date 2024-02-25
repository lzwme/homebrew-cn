cask "freetube" do
  version "0.19.2"
  sha256 "79f32c0bbcad1431528da16bf628782233a9c7e7a0854e037b95fcb16b62790e"

  url "https:github.comFreeTubeAppFreeTubereleasesdownloadv#{version}-betafreetube-#{version}-mac-x64.dmg"
  name "FreeTube"
  desc "YouTube player focusing on privacy"
  homepage "https:github.comFreeTubeAppFreeTube"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)i)
  end

  depends_on macos: ">= :high_sierra"

  app "FreeTube.app"

  uninstall quit: "io.freetubeapp.freetube"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsio.freetubeapp.freetube.sfl*",
    "~LibraryApplication SupportFreeTube",
    "~LibraryPreferencesio.freetubeapp.freetube.plist",
    "~LibrarySaved Application Stateio.freetubeapp.freetube.savedState",
  ]

  caveats do
    requires_rosetta
  end
end