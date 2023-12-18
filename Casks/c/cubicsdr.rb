cask "cubicsdr" do
  version "0.2.5"
  sha256 "9180e56e84a1d78935fb13ce362e3b8636a96b38d0695748078b43f9f6c3cb2c"

  url "https:github.comcjcliffeCubicSDRreleasesdownload#{version}CubicSDR-#{version}-Darwin.dmg",
      verified: "github.comcjcliffeCubicSDR"
  name "CubicSDR"
  desc "Cross-platform software-defined radio application"
  homepage "https:cubicsdr.com"

  livecheck do
    skip "No reliable way to get version info"
  end

  app "CubicSDR.app"
end