cask "piclist" do
  arch arm: "arm64", intel: "x64"

  version "2.9.9"
  sha256 arm:   "42da8b0730679e5ab1f3ea44417a8275a7af60f21b818004eba6f9ba1616cb7c",
         intel: "73bdbdd4afebac99f8e060a1ac5c6e926737b478a0a708092079b7343cdb081a"

  url "https:github.comKuingsmilePicListreleasesdownloadv#{version}PicList-#{version}-#{arch}.dmg",
      verified: "github.comKuingsmilePicList"
  name "PicList"
  desc "Cloud storage manager tool"
  homepage "https:piclist.cn"

  livecheck do
    url "https:release.piclist.cnlatestlatest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "PicList.app"

  zap trash: [
    "~LibraryApplication Supportpiclist",
    "~LibraryPreferencescom.kuingsmile.piclist.plist",
    "~LibrarySaved Application Statecom.kuingsmile.piclist.savedState",
  ]
end