cask "archivewebpage" do
  version "0.15.3"
  sha256 "86f13f02ed8cdb9b58d7c47c506285f93e089254231b0cab4d1c4ab0f1a96fdc"

  url "https://ghfast.top/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end