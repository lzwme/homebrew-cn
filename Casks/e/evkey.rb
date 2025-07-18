cask "evkey" do
  version "3.3.8"
  sha256 :no_check

  url "https://ghfast.top/https://github.com/lamquangminh/EVKey/releases/download/Release/EVKeyMac.zip",
      verified: "github.com/lamquangminh/EVKey/"
  name "EVKey"
  desc "Vietnamese keyboard"
  homepage "https://evkeyvn.com/"

  livecheck do
    url :homepage
    regex(/EVKeyMac\.zip.*?v?(\d+(?:\.\d+)+)/im)
  end

  no_autobump! because: :requires_manual_review

  app "EVKey.app"

  zap trash: [
    "~/Library/Containers/com.lamquangminh.evkey",
    "~/Library/Containers/com.lamquangminh.evkeyhelper",
  ]
end