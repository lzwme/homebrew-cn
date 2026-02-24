cask "cables" do
  arch arm: "-arm64", intel: "-x64"

  version "0.10.1"
  sha256 arm:   "cd9cade00f22ba60fc38389043612771413333c4e027ec0834c4f90f51893786",
         intel: "af9109585f3c3c312b69b6a5b46a72e61483cffab65dec07277d9def8d96b9db"

  url "https://ghfast.top/https://github.com/cables-gl/cables_electron/releases/download/v#{version}/cables-#{version}-mac#{arch}.dmg"
  name "Cables"
  desc "Visual programming tool"
  homepage "https://github.com/cables-gl/cables_electron"

  livecheck do
    url "https://dev.cables.gl/api/downloads/latest/"
    strategy :json do |json|
      json["name"]
    end
  end

  app "cables-#{version}.app"

  zap trash: [
    "~/Library/Application Support/cables_electron",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/gl.cables.standalone.sfl*",
    "~/Library/Logs/cables_electron",
    "~/Library/Preferences/gl.cables.standalone.plist",
    "~/Library/Saved Application State/gl.cables.standalone.savedState",
  ]
end