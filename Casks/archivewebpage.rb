cask "archivewebpage" do
  version "0.11.3"
  sha256 "1fd1877ab69f0c48ea75bfb295a9e9c2fe132055920740ecbc5bd5bdf6d6303b"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end