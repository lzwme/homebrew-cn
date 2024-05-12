cask "chipmunk" do
  version "3.12.5"
  sha256 "84a8183b0ba925ef782668670daeb49c34016370737449066cdf620e3d16a7cd"

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