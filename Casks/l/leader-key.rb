cask "leader-key" do
  version "1.12.0"
  sha256 "9d66a67bad858191223f736fde0127f7eb80d8a6c001aaf95cef39ba6efc0024"

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