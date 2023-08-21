cask "archivewebpage" do
  version "0.11.1"
  sha256 "ab69b1c6b3db4678cfc8201ae1b47067557af900ed53727b9bf19ffb6825a64c"

  url "https://ghproxy.com/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end