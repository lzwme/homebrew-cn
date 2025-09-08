cask "archivewebpage" do
  version "0.15.4"
  sha256 "c6963ce75a558b163ec4dd92b9949f735a5896deac989e111d057de88be4faec"

  url "https://ghfast.top/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end