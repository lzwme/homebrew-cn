cask "freetube" do
  version "0.21.3"
  sha256 "6279d5195352e916cc0b78b8fb69bb0014332623c424653e8f4a4d9d8a59e03b"

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