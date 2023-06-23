cask "archivewebpage" do
  version "0.10.0"
  sha256 "f85d76daa3f8ab591e079459dee98f946c34e2b7f2fcccfbf7d07aea124618cd"

  url "https://ghproxy.com/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end