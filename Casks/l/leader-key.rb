cask "leader-key" do
  version "1.17.1"
  sha256 "4a94f577eb864bdb6a79892104065933412a8b171797be3eaaf0d5a4fa8dffbf"

  url "https://ghfast.top/https://github.com/mikker/LeaderKey.app/releases/download/v#{version}/Leader.Key.app.zip"
  name "Leader Key"
  desc "Application launcher"
  homepage "https://github.com/mikker/LeaderKey.app"

  livecheck do
    url "https://mikker.github.io/LeaderKey.app/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Leader Key.app"

  zap trash: "~/Library/Application Support/Leader Key"
end