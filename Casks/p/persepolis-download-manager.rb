cask "persepolis-download-manager" do
  version "5.0.0"
  sha256 "b1009cf8308dccd29ae79e37582ff0c78adf632ac43f9479c9c23b9dcd2500af"

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