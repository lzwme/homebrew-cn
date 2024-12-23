cask "darktable" do
  arch arm: "arm64", intel: "x86_64"

  version "5.0.0"
  sha256 arm:   "14feb35ef2b2e8e50cf1855826ad4913e905a5600a56a87dd98382e8d828e9db",
         intel: "3f49cfb63958269b99065cf6b501678d4e63f2457ee1915bcd7ffa0dfef9dcfd"

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