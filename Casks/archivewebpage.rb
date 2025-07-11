cask "archivewebpage" do
  version "0.15.2"
  sha256 "badb53086e993d3797f73c5d52e41d2db1f8064cb88c48d551d5ce6ce19c130a"

  url "https://ghfast.top/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end