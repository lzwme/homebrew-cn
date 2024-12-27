cask "virtualc64" do
  # NOTE: "64" is not a version number, but an intrinsic part of the product name
  version "5.1"
  sha256 "01f62934c7ef2b9e223121639a0933fbcc56ac5555f22feb21a8ed5b3054a29f"

  url "https:github.comdirkwhoffmannvirtualc64releasesdownloadv#{version}VirtualC64.app.zip",
      verified: "github.comdirkwhoffmannvirtualc64"
  name "VirtualC64"
  desc "Cycle-accurate C64 emulator"
  homepage "https:dirkwhoffmann.github.iovirtualc64"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :ventura"

  app "VirtualC64.app"

  zap trash: [
    "~LibraryApplication SupportVirtualC64",
    "~LibraryCachesde.dirkwhoffmann.VirtualC64",
    "~LibraryPreferencesde.dirkwhoffmann.VirtualC64.plist",
  ]
end