cask "darktable" do
  arch arm: "arm64", intel: "x86_64"

  version "5.0.1"
  sha256 arm:   "66296ab8d26e4ac14061a5407eafe0f31ddb7ac1de9995bd2e05043e9c0b0c60",
         intel: "ce05f2a9efa4cde090a939e42813ee98cf98f5b5e6a14304c9d8c3d71a589a01"

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