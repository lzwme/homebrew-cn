cask "leader-key" do
  version "1.14.0"
  sha256 "c28c705465839f5347ea38da70c3454c650f70629babf953266a6e42a30472d8"

  url "https:github.commikkerLeaderKey.appreleasesdownloadv#{version}Leader.Key.app.zip"
  name "Leader Key"
  desc "Application launcher"
  homepage "https:github.commikkerLeaderKey.app"

  livecheck do
    url "https:mikker.github.ioLeaderKey.appappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Leader Key.app"

  zap trash: "~LibraryApplication SupportLeader Key"
end