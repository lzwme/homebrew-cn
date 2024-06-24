cask "archivewebpage" do
  version "0.12.2"
  sha256 "cc6198229baeef7afab9210dd20a0cdd96d0fc4b50605e83a86a72dcdf610d64"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end