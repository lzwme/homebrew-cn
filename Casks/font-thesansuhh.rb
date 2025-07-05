require_relative "../lib/b2_download_strategy" unless defined?(B2DownloadStrategy)

cask "font-thesansuhh" do
  version "1.003"
  sha256 :no_check

  url "b2://backblazeb2.com/brewery/fonts/thesansuhh-1.003.zip",
      verified: "backblazeb2.com/brewery/"
  name "TheSansUHH"
  desc "TheSansUHH font family"
  homepage "https://github.com/codello/homebrew-brewery"

  font "TheSansUHH Regular.ttf"
  font "TheSansUHH Bold.ttf"
  font "TheSansUHH Regular Italic.ttf"
  font "TheSansUHH_TT_Bold_Caps.ttf"
  font "TheSansUHH_TT_SemiLight_Caps.ttf"
end