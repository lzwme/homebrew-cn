cask "clop" do
  version "2.5.5"
  sha256 "8a8a170f3a7d10a7495367c55a57f8044c4da3f0f2e43ed3bd5abd9cb71ad8ff"

  url "https://files.lowtechguys.com/releases/Clop-#{version}.dmg"
  name "Clop"
  desc "Image, video and clipboard optimiser"
  homepage "https://lowtechguys.com/clop/"

  livecheck do
    url "https://files.lowtechguys.com/clop/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Clop.app"

  zap trash: [
    "~/Library/Application Support/Clop",
    "~/Library/Caches/Clop",
    "~/Library/Preferences/com.lowtechguys.Clop.plist",
  ]
end