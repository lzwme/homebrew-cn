cask "bathyscaphe" do
  version "3.2.1,1101"
  sha256 "d184edaabe6d8132063dad948665076277de8bb582529724d3c2d053c9af7f98"

  url "https://bitbucket.org/bathyscaphe/public/downloads/BathyScaphe-#{version.csv.first.no_dots}-v#{version.csv.second}.zip",
      verified: "bitbucket.org/bathyscaphe/public/downloads/"
  name "BathyScaphe"
  desc "2-channel browser"
  homepage "https://bathyscaphe.bitbucket.io/"

  livecheck do
    url "https://bathyscaphe.bitbucket.io/appcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "BathyScaphe.app"

  zap trash: [
    "~/Library/Application Support/BathyScaphe",
    "~/Library/Caches/jp.tsawada2.BathyScaphe",
    "~/Library/HTTPStorages/jp.tsawada2.BathyScaphe",
    "~/Library/Preferences/jp.tsawada2.BathyScaphe.plist",
    "~/Library/Saved Application State/jp.tsawada2.BathyScaphe.savedState",
  ]
end