cask "mtmr" do
  version "0.27.0"
  sha256 "cf0b1b8cb9d6758cd0b69d2c4c5f9f1a067416126a7daa76a8d94fea8189d608"

  url "https:github.comToxblhMTMRreleasesdownloadv#{version}MTMR.#{version.major_minor}.dmg"
  name "My TouchBar. My rules"
  desc "TouchBar customization app"
  homepage "https:github.comToxblhMTMR"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "MTMR.app"

  zap trash: "~LibraryApplication SupportMTMR"

  caveats do
    requires_rosetta
  end
end