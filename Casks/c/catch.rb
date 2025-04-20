cask "catch" do
  version "2.3"
  sha256 "8e138ec2c3e2d2a9f66eabc534f32f3ca64a3cd967b8896a3feddd438b391411"

  url "https:github.commipstiancatchreleasesdownload#{version}Catch-#{version}.zip",
      verified: "github.commipstiancatch"
  name "Catch"
  desc "Broadcatching made easy"
  homepage "https:www.giorgiocalderolla.comcatch.html"

  livecheck do
    url "https:raw.github.commipstiancatchmasterupdateappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Catch.app"

  zap trash: "~LibraryPreferencesorg.giorgiocalderolla.Catch.plist"
end