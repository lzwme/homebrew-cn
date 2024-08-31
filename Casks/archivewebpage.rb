cask "archivewebpage" do
  version "0.12.7"
  sha256 "75d94de545daa43bc01899fddbfe1dbde4589e595a4b09eb35825bf2959fbc49"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end