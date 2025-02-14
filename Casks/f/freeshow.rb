cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.3.8"
  sha256 arm:   "304ad1727c9b687439d464d908832107b77b87bd9319346ca19421ec43c06628",
         intel: "c7745d9d7d5fa7222bb6af9edf72d5d93e9b279d8fee3926dd805b6f61df6cc6"

  url "https:github.comChurchAppsFreeShowreleasesdownloadv#{version}FreeShow-#{version}-#{arch}.zip",
      verified: "github.comChurchApps"
  name "FreeShow"
  desc "Presentation software"
  homepage "https:freeshow.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "FreeShow.app"

  zap trash: [
        "~LibraryApplication Supportfreeshow",
        "~LibraryPreferencesapp.freeshow.plist",
        "~LibrarySaved Application Stateapp.freeshow.savedState",
      ],
      rmdir: "~DocumentsFreeShow"
end