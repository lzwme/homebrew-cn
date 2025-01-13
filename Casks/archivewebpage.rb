cask "archivewebpage" do
  version "0.14.2"
  sha256 "4fa1d96da05bc13f0907a601cd358ad397c7040a655407e68a65f24639b55b5e"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end