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
    version "0.23.1"
    sha256 arm:   "0a6131658230d20b34a055e58c53a0a8f5c3adeb13ed6c19312e383b08da7c1f",
           intel: "29524f9653569bf81c65cdfd9138320ea10eaca93d3ef2653a411d89b76f782a"

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