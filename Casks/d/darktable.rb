cask "darktable" do
  arch arm: "arm64", intel: "x86_64"

  version "4.8.0"
  sha256 arm:   "628442bf336e4f51fdf39f8b144372cbd855fe7b17812e359b5f8f3e6b6d99fb",
         intel: "bded6986f72af8901f0fa28686d6d06e6b766d831c29abe8a0163b5a503a50e6"

  url "https:github.comdarktable-orgdarktablereleasesdownloadrelease-#{version.major_minor_patch}darktable-#{version}-#{arch}.dmg",
      verified: "github.comdarktable-orgdarktable"
  name "darktable"
  desc "Photography workflow application and raw developer"
  homepage "https:www.darktable.org"

  livecheck do
    url "https:www.darktable.orginstall"
    regex(href=.*?darktable[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  depends_on macos: ">= :ventura"

  app "darktable.app"

  zap trash: [
    "~.cachedarktable",
    "~.configdarktable",
    "~.localsharedarktable",
    "~LibrarySaved Application Stateorg.darktable.savedState",
  ]
end