cask "115" do
  # NOTE: "115" is not a version number, but an intrinsic part of the product name
  version "2.0.10.2"
  sha256 "83b45692a449220cb1918f1ca4fbf329e87cbc2c4810e44b2e312df30797c1bb"

  url "https://down.115.com/client/115pc/mac/115pc_v#{version}.dmg"
  name "115"
  name "115桌面版"
  desc "Client for the 115 cloud storage service"
  homepage "https://pc.115.com/index.html#mac"

  livecheck do
    url "https://appversion.115.com/1/web/1.0/api/chrome"
    strategy :json do |json|
      json["data"]["mac_115"]["version_code"]
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "115生活.app"

  uninstall quit: "org.115pc.115Desktop"

  zap trash: [
    "~/Library/Application Support/115*",
    "~/Library/Saved Application State/org.115pc.115*",
  ]
end