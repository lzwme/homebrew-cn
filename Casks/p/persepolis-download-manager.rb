cask "persepolis-download-manager" do
  version "4.3.0"
  sha256 "343286a5972c8added71af90177e1a45cb19a18691314b958ba2edff2dd44564"

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

  caveats do
    requires_rosetta
  end
end