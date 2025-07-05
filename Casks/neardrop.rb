cask "neardrop" do
  version "2.1.0"
  sha256 "3eaaf874019f9fdef7b7dd0494e7a9005ba81558c0733f931757c9518c6d226b"

  url "https://ghfast.top/https://github.com/grishka/NearDrop/releases/download/v#{version}/NearDrop.app.zip"
  name "NearDrop"
  desc "Unofficial Google Nearby Share app"
  homepage "https://github.com/grishka/NearDrop"

  app "NearDrop.app"
end