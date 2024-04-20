cask "obs-backgroundremoval" do
  version "1.1.13"
  sha256 "e032871f920f8518d4660089a045dce8bd682539182a9a0c4f027fe7767fb797"

  url "https:github.comocc-aiobs-backgroundremovalreleasesdownload#{version}obs-backgroundremoval-#{version}-macos-universal.pkg",
      verified: "github.comocc-aiobs-backgroundremoval"
  name "OBS Background Removal"
  desc "Virtual Green-screen and Low-Light Enhancement OBS Plugin"
  homepage "https:obsproject.comforumresourcesbackground-removal-virtual-green-screen-low-light-enhance.1260"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  pkg "obs-backgroundremoval-#{version}-macos-universal.pkg"

  uninstall pkgutil: "com.royshilkrot.obs-backgroundremoval",
            delete:  "~LibraryApplication Supportobs-studiopluginsobs-backgroundremoval.plugin",
            rmdir:   "~LibraryApplication Supportobs-studioplugins"

  # No zap stanza required
end