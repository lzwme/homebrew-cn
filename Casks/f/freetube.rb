cask "freetube" do
  arch arm: "arm64", intel: "x64"

  on_catalina do
    version "0.22.1"
    sha256 "0e9eb9db841f36671c81fedff4580c39dbbd6bd541d5158ed4897218c4134946"

    url "https:github.comFreeTubeAppFreeTubereleasesdownloadv#{version}-betafreetube-#{version}-mac-x64.dmg",
        verified: "github.comFreeTubeAppFreeTube"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "0.23.2"
    sha256 arm:   "488dfe64f037e753c3de7322eb21e07e8900d88329fb8aef629b60445ab38dcf",
           intel: "2e7de3dd0dd7343673d24a65c13471edc69d09b675190ea9b6e7d04ec94c2993"

    url "https:github.comFreeTubeAppFreeTubereleasesdownloadv#{version}-betafreetube-#{version}-mac-#{arch}.dmg",
        verified: "github.comFreeTubeAppFreeTube"

    livecheck do
      url :url
      regex(^v?(\d+(?:\.\d+)+)i)
    end
  end

  name "FreeTube"
  desc "YouTube player focusing on privacy"
  homepage "https:freetubeapp.io"

  depends_on macos: ">= :catalina"

  app "FreeTube.app"

  uninstall quit: "io.freetubeapp.freetube"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsio.freetubeapp.freetube.sfl*",
    "~LibraryApplication SupportFreeTube",
    "~LibraryPreferencesio.freetubeapp.freetube.plist",
    "~LibrarySaved Application Stateio.freetubeapp.freetube.savedState",
  ]
end