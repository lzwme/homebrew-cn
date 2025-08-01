cask "ifunbox" do
  version "1.8"
  sha256 "19bef7c6079cb3d13dc109478c473e420643e3164ed02b668f76220f60884a11"

  url "http://dl.i-funbox.com/mac/ifunboxmac.#{version}.dmg"
  name "iFunBox"
  desc "File management software for iPhone and other Apple products"
  homepage "https://www.i-funbox.com/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-03-31", because: :unmaintained

  app "iFunBox.app"

  zap trash: [
    "~/Library/Caches/com.iFunBoxDevTeam.iFunBox",
    "~/Library/Preferences/com.iFunBoxDevTeam.iFunBox.plist",
  ]

  caveats do
    requires_rosetta
  end
end