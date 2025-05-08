cask "archivewebpage" do
  version "0.15.1"
  sha256 "c8e0a944c7ffcd3acdc023436b544a66b66e1446e4a4589e8c8ce2ba997577cf"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end