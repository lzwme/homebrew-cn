cask "leader-key" do
  version "1.11.0"
  sha256 "c61521ce11ceaff1fc074a3de6ff7fb3f91721bb71e057115301f486b3260b67"

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