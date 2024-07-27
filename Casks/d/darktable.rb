cask "darktable" do
  arch arm: "arm64", intel: "x86_64"

  version "4.8.1"
  sha256 arm:   "1947ffb16f1fcc21d43c7bc7002e79f49fa82ee3d17a76832c11ee6b4d3cad73",
         intel: "84698315ad23c745cb126b5b695b211781f3e6355924cb9016e36d4c2dc0c6f7"

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