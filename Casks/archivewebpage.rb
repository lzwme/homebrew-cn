cask "archivewebpage" do
  version "0.15.1"
  sha256 "c8e0a944c7ffcd3acdc023436b544a66b66e1446e4a4589e8c8ce2ba997577cf"

  url "https://ghfast.top/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end