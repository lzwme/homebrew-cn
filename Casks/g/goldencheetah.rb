cask "goldencheetah" do
  version "3.7"
  sha256 "000f49df0cb3da1b8b48656f8c0fecb7591be9a0d3eae400d54b76d52d465363"

  url "https:github.comGoldenCheetahGoldenCheetahreleasesdownloadv#{version}GoldenCheetah_v#{version}_x64.dmg",
      verified: "github.comGoldenCheetahGoldenCheetah"
  name "GoldenCheetah"
  desc "Performance software for cyclists, runners and triathletes"
  homepage "https:www.goldencheetah.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "GoldenCheetah.app"

  caveats do
    requires_rosetta
  end
end