cask "archivewebpage" do
  version "0.11.0"
  sha256 "e23e8b16011feda4d7ebeec2a223e1896553c5f8309240a11ae4340bedc4c8f1"

  url "https://ghproxy.com/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end