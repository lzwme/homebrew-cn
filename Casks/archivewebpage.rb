cask "archivewebpage" do
  version "0.11.2"
  sha256 "fa44b46844cabb474362e06b77da53405e0c4717b4fcea5bb64eef8e531ae290"

  url "https://ghproxy.com/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end