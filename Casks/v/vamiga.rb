cask "vamiga" do
  version "4.2"
  sha256 "d6893a0821c6ce0ae8a6a0dd20fbe6aaa561e938999700de1e7b7840e188e4b1"

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