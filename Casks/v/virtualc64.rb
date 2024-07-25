cask "virtualc64" do
  # NOTE: "64" is not a version number, but an intrinsic part of the product name
  version "5.0.1"
  sha256 "3cbd0e84f09d241a72a383806564d64b3e3bfba71c02ae02ce680fed246527e3"

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