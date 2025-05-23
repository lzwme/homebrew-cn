cask "virtualc64" do
  # NOTE: "64" is not a version number, but an intrinsic part of the product name
  version "5.2"
  sha256 "eabf0c7d01092bbb13c01be00c6862f8422c929e5f0f4112643cc871169c27ea"

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