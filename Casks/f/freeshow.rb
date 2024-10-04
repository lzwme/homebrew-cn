cask "freeshow" do
  arch arm: "arm64", intel: "x64"

  version "1.2.8"
  sha256 arm:   "6b8d96e86fdd64387551983142a0ce252479cd7efd96cd184ea508c972271865",
         intel: "0b772ace4c1011042395d79cabba68c223914723d57ab2f4889b1a4f6860dd6b"

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