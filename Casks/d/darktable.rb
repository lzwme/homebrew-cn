cask "darktable" do
  arch arm: "arm64", intel: "x86_64"

  version "4.6.0"
  sha256 arm:   "c2649a07410d70f5da57f9c3583f24c6a97adb994924af88f132a2232ddf7ab4",
         intel: "e4e53cc1ec6a5800029f39728c024882a0357458f5c8d8e0ff16dfe034e701ed"

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