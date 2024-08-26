cask "statusfy" do
  version "1.4.0"
  sha256 "7fcd2bf27000bec59ef76343621fc4c551c68dd5ab338742ca824b2c5fe0771b"

  url "https:github.compaulyoungStatusfyreleasesdownload#{version}Statusfy.zip"
  name "Statusfy"
  desc "Spotify in the status bar"
  homepage "https:github.compaulyoungStatusfy"

  deprecate! date: "2024-08-25", because: :unmaintained

  app "Statusfy.app"

  caveats do
    requires_rosetta
  end
end