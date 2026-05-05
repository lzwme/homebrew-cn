cask "masscode" do
  arch arm: "-arm64"

  version "5.3.0"
  sha256 arm:   "7f913190d10f077d77add9933077c63830725bd3df85002f6fe4b24cbbb16ad4",
         intel: "0f9788d1accac50f954166f568ec5dfe64cb5f53fd17268bb05b525203d78920"

  url "https://ghfast.top/https://github.com/massCodeIO/massCode/releases/download/v#{version}/massCode-#{version}#{arch}.dmg",
      verified: "github.com/massCodeIO/massCode/"
  name "massCode"
  desc "Code snippets manager for developers"
  homepage "https://masscode.io/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "massCode.app"

  zap trash: [
        "~/Library/Application Support/massCode",
        "~/Library/Preferences/io.masscode.app.plist",
        "~/Library/Saved Application State/io.masscode.app.savedState",
      ],
      rmdir: "~/massCode"
end