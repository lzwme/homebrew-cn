cask "evkey" do
  version "3.3.8"
  sha256 :no_check

  url "https:github.comlamquangminhEVKeyreleasesdownloadReleaseEVKeyMac.zip",
      verified: "github.comlamquangminhEVKey"
  name "EVKey"
  desc "Vietnamese keyboard"
  homepage "https:evkeyvn.com"

  livecheck do
    url :homepage
    regex(EVKeyMac\.zip.*?v?(\d+(?:\.\d+)+)im)
  end

  no_autobump! because: :requires_manual_review

  app "EVKey.app"

  zap trash: [
    "~LibraryContainerscom.lamquangminh.evkey",
    "~LibraryContainerscom.lamquangminh.evkeyhelper",
  ]
end