cask "zesarux" do
  version "11.0"
  sha256 "396e0410c97297dfb519e0445ddf60e2eee7e7ff727b6d38e9866eca81a8cef0"

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

  caveats do
    requires_rosetta
  end
end