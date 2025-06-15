cask "macmorpheus" do
  version "0.2"
  sha256 "06c75fceafdd52336c78d2129e98e3452183e126da69939037bbe0c1fdf03726"

  url "https:github.comemoRaivisMacMorpheusreleasesdownload#{version}MacMorpheus.app.zip"
  name "MacMorpheus"
  desc "3D 180360 video player using PSVR"
  homepage "https:github.comemoRaivisMacMorpheus"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-27", because: :unmaintained

  app "MacMorpheus.app"

  zap trash: "~LibraryPreferencesemoRaivis.MacMorpheus.plist"

  caveats do
    requires_rosetta
  end
end