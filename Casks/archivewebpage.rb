cask "archivewebpage" do
  version "0.10.1"
  sha256 "50f03646cedd6aa73bfaee8b9be040c2603d24aa782f5322b75920b0bc738c9b"

  url "https://ghproxy.com/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end