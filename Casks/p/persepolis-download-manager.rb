cask "persepolis-download-manager" do
  version "5.0.1"
  sha256 "a2b178da461c1095c6f897fd243663483a1ec09ec3f5a41158fae6043a195240"

  url "https:github.compersepolisdmpersepolisreleasesdownload#{version}persepolis_#{version}_macos.dmg",
      verified: "github.compersepolisdmpersepolis"
  name "Persepolis"
  desc "Download manager"
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