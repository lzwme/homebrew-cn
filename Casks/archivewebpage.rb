cask "archivewebpage" do
  version "0.12.0"
  sha256 "a74fc0c356a25281e8b222726372bd9def568a0f0a67cc49c5807ada1c604e4d"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end