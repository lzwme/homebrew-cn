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
    version "0.23.3"
    sha256 arm:   "1e6aa2f663db9e55830e7dd941c9beda74438fc0a442bc71add9bf2d1176dfc6",
           intel: "da5b06ed4b0e54d5c8ea21093ab7d192c4de63aadc1f45c75956990ef66436e1"

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