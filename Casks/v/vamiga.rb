cask "vamiga" do
  version "4.2.1"
  sha256 "f086416d083373ac73314e79a8cbe0a4aad54a228e34e3e7af3fdf79f4ad38df"

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