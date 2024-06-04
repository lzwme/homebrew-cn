cask "persepolis-download-manager" do
  version "4.2.0"
  sha256 "b3219945bc4e49a0eddfbcd05df9ffa6c0790249ff4095cd6a0faad64343d462"

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