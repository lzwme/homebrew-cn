cask "leader-key" do
  version "1.10.1"
  sha256 "f7b76965be9d41ad8d086ed26399e78e48aa31de769c04c66dcba1e554edcd95"

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