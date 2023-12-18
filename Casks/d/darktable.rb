cask "darktable" do
  arch arm: "arm64", intel: "x86_64"

  version "4.4.2"
  sha256 arm:   "4576f4cc25f96d5a2334993bb847e826591b3190ddf24fb83461df093ce8ee2a",
         intel: "9eb84ea041daad704a8d4226d8c7cba77522dcd003d7166961869b1cfaa9ac9a"

  url "https:github.comdarktable-orgdarktablereleasesdownloadrelease-#{version.major_minor_patch}darktable-#{version}-#{arch}.dmg",
      verified: "github.comdarktable-orgdarktable"
  name "darktable"
  desc "Photography workflow application and raw developer"
  homepage "https:www.darktable.org"

  livecheck do
    url "https:www.darktable.orginstall"
    regex(href=.*?darktable[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  app "darktable.app"

  zap trash: [
    "~.cachedarktable",
    "~.configdarktable",
    "~.localsharedarktable",
    "~LibrarySaved Application Stateorg.darktable.savedState",
  ]
end