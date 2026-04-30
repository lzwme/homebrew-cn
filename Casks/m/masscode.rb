cask "masscode" do
  arch arm: "-arm64"

  version "5.2.0"
  sha256 arm:   "43836ea79ad9d4e52a4c952215d0231044407490271004a0a274540c929f2083",
         intel: "5f0da6d8c20ab3f3a55956f85e606100636d1a40fa5c8478eb116baf2449c90c"

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