cask "editaro" do
  version "1.7.1"
  sha256 "e5efe1de1283df05ad0bb2908c16c02bc0c34806119e83daefc0f049286f3c58"

  url "https://ghfast.top/https://github.com/kkosuge/editaro/releases/download/#{version}/Editaro-#{version}-mac.zip",
      verified: "github.com/kkosuge/editaro/"
  name "Editaro"
  desc "Text editor"
  homepage "https://editaro.com/"

  livecheck do
    url "https://hazel.editaro.com/update/mac/0.0.0"
    strategy :json do |json|
      json["name"]
    end
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "Editaro.app"

  zap trash: [
    "~/Library/Application Support/Editaro",
    "~/Library/Caches/com.electron.editaro",
    "~/Library/Caches/com.electron.editaro.ShipIt",
    "~/Library/HTTPStorages/com.electron.editaro",
    "~/Library/Logs/Editaro",
    "~/Library/Preferences/com.electron.editaro.helper.plist",
    "~/Library/Preferences/com.electron.editaro.plist",
    "~/Library/Saved Application State/com.electron.editaro.savedState",
  ]

  caveats do
    requires_rosetta
  end
end