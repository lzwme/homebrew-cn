cask "persepolis-download-manager" do
  version "4.1.0"
  sha256 "db6afcd9322eeab2221e1ef93de6642bf5a4b5f4d1cd270cbec3b6ce704bd695"

  url "https:github.compersepolisdmpersepolisreleasesdownload#{version}persepolis_#{version}_macos.dmg",
      verified: "github.compersepolisdmpersepolis"
  name "Persepolis"
  desc "GUI for aria2"
  homepage "https:persepolisdm.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Persepolis Download Manager.app"

  zap trash: [
    "~.persepolis",
    "~LibraryApplication Supportpersepolis_download_manager",
  ]
end