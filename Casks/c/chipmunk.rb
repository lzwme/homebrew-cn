cask "chipmunk" do
  version "3.12.0"
  sha256 "96085dfcf051b41a501d999d6bb9ac4f47797296771cbb8ebaa4485974dd32fe"

  url "https:github.comesrlabschipmunkreleasesdownload#{version}chipmunk@#{version}-darwin-portable.tgz"
  name "Chipmunk Log Analyzer & Viewer"
  desc "Log analysis tool"
  homepage "https:github.comesrlabschipmunk"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "chipmunk.app"

  zap trash: "~.chipmunk"
end