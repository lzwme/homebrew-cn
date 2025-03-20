cask "thelowtechguys-cling" do
  version "1.2"
  sha256 "a8a9dbe97029ceb75041e2b872899bd4240806c1bac4329a7710204a2ab7fc7d"

  url "https://files.lowtechguys.com/releases/Cling-#{version}.dmg"
  name "The low-tech guys Cling"
  desc "Instant fuzzy finder for files including system and hidden files"
  homepage "https://lowtechguys.com/cling"

  livecheck do
    url "https://files.lowtechguys.com/cling/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Cling.app"

  zap trash: [
    "~/Library/Application Scripts/com.lowtechguys.Cling",
    "~/Library/Caches/Cling",
    "~/Library/Caches/com.lowtechguys.Cling",
    "~/Library/HTTPStorages/com.lowtechguys.Cling",
    "~/Library/Preferences/com.lowtechguys.Cling.plist",
  ]
end