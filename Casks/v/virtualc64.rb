cask "virtualc64" do
  # NOTE: "64" is not a version number, but an intrinsic part of the product name
  version "4.7"
  sha256 "d4c833b7d85cb5f2b4dcbb77fd1150cd941fe782d85c057755e3a00f02622964"

  url "https:github.comdirkwhoffmannvirtualc64releasesdownloadv#{version}VirtualC64.app.zip",
      verified: "github.comdirkwhoffmannvirtualc64"
  name "VirtualC64"
  desc "Cycle-accurate C64 emulator"
  homepage "https:dirkwhoffmann.github.iovirtualc64"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "VirtualC64.app"

  zap trash: [
    "~LibraryApplication SupportVirtualC64",
    "~LibraryCachesde.dirkwhoffmann.VirtualC64",
    "~LibraryPreferencesde.dirkwhoffmann.VirtualC64.plist",
  ]
end