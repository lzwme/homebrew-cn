cask "alcove" do
  version "1.6.8"
  sha256 "a36c9e3b9bc302b18d0e09fb9e6d42631d93bcec17b8685b2d619f0c735543dc"

  url "https://ghfast.top/https://github.com/henrikruscon/alcove-releases/releases/download/#{version}/Alcove.zip",
      verified: "github.com/henrikruscon/alcove-releases/"
  name "Alcove"
  desc "Utility to add Dynamic Island like features to notch area"
  homepage "https://tryalcove.com/"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Alcove.app"

  zap trash: [
    "~/Library/Caches/com.henrikruscon.Alcove",
    "~/Library/HTTPStorages/com.henrikruscon.Alcove",
    "~/Library/Preferences/com.henrikruscon.Alcove.plist",
  ]
end