cask "freetube" do
  version "0.19.1"
  sha256 "4a8f77000e01a6123a3252f5217744d6e9836f78642c222081917e2318fa1c60"

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