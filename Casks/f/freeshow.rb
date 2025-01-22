cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.3.4"
  sha256 arm:   "6b93efe7e74756803257231623a4456c67d66046a565ce452ef88437265b5fd9",
         intel: "7651cf3e8ad26b50dea20ba825f3455ab486db570bbe51c2de6914b3cbeb8fa3"

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