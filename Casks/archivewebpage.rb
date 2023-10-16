cask "archivewebpage" do
  version "0.11.3"
  sha256 "1fd1877ab69f0c48ea75bfb295a9e9c2fe132055920740ecbc5bd5bdf6d6303b"

  url "https://ghproxy.com/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end