cask "freetube" do
  version "0.21.0"
  sha256 "d8d26422ae356c748342bf32a405cd83402879c435db3dc6f02b3f1f890b6320"

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