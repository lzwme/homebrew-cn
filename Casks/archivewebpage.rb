cask "archivewebpage" do
  version "0.15.7"
  sha256 "8a3bd3662ca04152025faf50189851684edc482f8a71110c9989f5c9a0f4365c"

  url "https://ghfast.top/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  depends_on macos: ">= :monterey"

  app "ArchiveWeb.page.app"
end