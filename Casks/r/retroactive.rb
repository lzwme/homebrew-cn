cask "retroactive" do
  version "2.1"
  sha256 "5ef0aac063ab4f20579325481a0c75d14ed3d95576991c0c0767334ebabc38ca"

  url "https:github.comcormiertyshawn895Retroactivereleasesdownload#{version}Retroactive.#{version}.zip"
  name "Retroactive"
  desc "Run Apple apps on incompatible OS versions"
  homepage "https:github.comcormiertyshawn895Retroactive"

  app "Retroactive #{version}Retroactive (right click to open).app"

  zap delete: "~LibraryCachescom.retroactive.Retroactive"
end