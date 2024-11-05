cask "archivewebpage" do
  version "0.13.3"
  sha256 "272f8234e2fcde0d552e3929eee30fb9cb6a2407778d01d002ce625580b7d4b7"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end