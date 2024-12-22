cask "archivewebpage" do
  version "0.14.1"
  sha256 "47b5308617b7964b195b4e6a2dbd8aac25e8cdf8112c9d99d2e9b4acb6bf82fa"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https:archiveweb.page"

  app "ArchiveWeb.page.app"
end