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
    version "0.23.4"
    sha256 arm:   "665e44c78cbd89db35c3f97013c18dabbc41bca36a35233c71e0b2c2a9a8c457",
           intel: "a7905d41cf6a4d4117f199f74b8cf8fab0f4da5d2d76c51d43282328f894e8dd"

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