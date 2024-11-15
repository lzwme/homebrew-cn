cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.3.1"
  sha256 arm:   "ccd9e7b7f9abee395776e6930cbd384efef6bec05061fb7947fb5801863e4959",
         intel: "a8113c2ccb0bfa03e7614495ffc96c7a66516030e94acfff4fc2a0dfc1af1085"

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
  depends_on macos: ">= :high_sierra"

  app "FreeShow.app"

  zap trash: [
        "~LibraryApplication Supportfreeshow",
        "~LibraryPreferencesapp.freeshow.plist",
        "~LibrarySaved Application Stateapp.freeshow.savedState",
      ],
      rmdir: "~DocumentsFreeShow"
end