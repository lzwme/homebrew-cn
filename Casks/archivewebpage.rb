cask "archivewebpage" do
  version "0.16.0"
  sha256 "752f9880793bd82fd93b873bfa448d4e785dae2057db476605b27afcd04afe60"

  url "https://ghfast.top/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Interactive browser-based web archiving"
  homepage "https://archiveweb.page/"

  app "ArchiveWeb.page.app"
end