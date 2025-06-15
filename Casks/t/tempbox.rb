cask "tempbox" do
  version "1.1"
  sha256 "edcd68709cd69363de8535fc3f14ed9819004aba3edea9def10b540e44383e8b"

  url "https:github.comdevwaseemTempBoxreleasesdownloadv#{version}TempBox.dmg",
      verified: "github.comdevwaseemTempBox"
  name "Tempbox"
  desc "Disposable email client"
  homepage "https:tempbox.waseem.works"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "TempBox.app"

  zap trash: [
    "~LibraryApplication Scriptscom.waseem.TempBox",
    "~LibraryContainerscom.waseem.TempBox",
  ]
end