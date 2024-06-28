cask "vamiga" do
  version "2.6"
  sha256 "bbefbbd516795b84d8fcb91f8b36f2d17ae074e489e4e285dd2590b077befa9e"

  url "https:github.comdirkwhoffmannvAmigareleasesdownloadv#{version}vAmiga.app.zip",
      verified: "github.comdirkwhoffmannvAmiga"
  name "vAmiga"
  desc "Amiga 500, 1000, 2000 emulator"
  homepage "https:dirkwhoffmann.github.iovAmiga"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "vAmiga.app"

  zap trash: [
    "~LibraryApplication SupportvAmiga",
    "~LibraryPreferencesdirkwhoffmann.vAmiga.plist",
  ]
end