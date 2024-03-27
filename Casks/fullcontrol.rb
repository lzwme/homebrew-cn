cask "fullcontrol" do
  version "3.3"
  sha256 "34d4b2248bb2140ae1bcf7dc8381d1ddda4aaacb5ae714993d73edce3e1ac97d"

  url "https://fullcontrol.cescobaz.com/download/Mac/3.3/FullControlHelper_#{version}.dmg"
  name "FullControl"
  desc "Helper application for the FullControl server"
  homepage "https://fullcontrol.cescobaz.com/"

  app "FullControlHelper.app"

  zap trash: [
    "~/Library/Application Support/com.cescobaz.FullControlHelper",
    "~/Library/Caches/com.cescobaz.FullControlHelper",
    "~/Library/Preferences/com.cescobaz.FullControlHelper.plist",
  ]
end