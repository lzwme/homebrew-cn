cask "vamiga" do
  version "3.2"
  sha256 "3d0c64fa3a665cf948084526c36414cbe43bc3118243f27f1f0823a170e34b41"

  url "https:github.comdirkwhoffmannvAmigareleasesdownloadv#{version}vAmiga.app.zip",
      verified: "github.comdirkwhoffmannvAmiga"
  name "vAmiga"
  desc "Amiga 500, 1000, 2000 emulator"
  homepage "https:dirkwhoffmann.github.iovAmiga"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "vAmiga.app"

  zap trash: [
    "~LibraryApplication SupportvAmiga",
    "~LibraryPreferencesdirkwhoffmann.vAmiga.plist",
  ]
end