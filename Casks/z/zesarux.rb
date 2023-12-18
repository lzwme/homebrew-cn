cask "zesarux" do
  version "X"
  sha256 "b1a4c58fd21b926bd7edb1232596ceeff91c774454e1207d9a0f7ce1e56ef558"

  url "https:github.comchernandezbazesaruxreleasesdownloadZEsarUX-#{version}ZEsarUX_macos-#{version}.dmg"
  name "ZEsarUX"
  desc "ZX machines emulator"
  homepage "https:github.comchernandezbazesarux"

  livecheck do
    url :url
    regex(ZEsarUX[._-]v?([\dX]+(?:\.\d+)*)i)
    strategy :github_latest
  end

  app "ZEsarUX.app"

  zap trash: [
    "~.zesaruxrc",
    "~LibrarySaved Application Statecom.cesarhernandez.zesarux.savedState",
  ]
end