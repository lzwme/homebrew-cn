cask "vamiga" do
  version "2.5"
  sha256 "fd082228441159680ba2f451245dd49c910f9dd877def7367fbca6070bfef3e6"

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