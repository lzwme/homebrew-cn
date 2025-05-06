cask "archivewebpage" do
  version "0.15.0"
  sha256 "10df19c1af75dc81afc9b5b63c42b5510852268c7b5523597843778876eaa4ca"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end