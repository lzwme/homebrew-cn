cask "leader-key" do
  version "1.15.0"
  sha256 "72a24395f1d3333f192e81d9fba9e4d1f0baae2d76a4fa7b316f4d28e86f14ff"

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