cask "archivewebpage" do
  version "0.11.4"
  sha256 "cd7535f00ea5a88157632b6730948f311a29b7dd80aa962b459a8c7423fe28c6"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end