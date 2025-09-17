cask "archivewebpage" do
  version "0.15.5"
  sha256 "2c6679785c0b8bc37da6bc4f36e1fe891f226e416b01f6fa8be67c47314b0260"

  url "https://ghfast.top/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end