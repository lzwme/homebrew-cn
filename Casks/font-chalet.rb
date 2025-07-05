cask "font-chalet" do
  version "1.0"
  sha256 :no_check

  url "https://github.com/google/eddystone/raw/master/branding/assets/Font/Chalet.zip",
      verified: "github.com/google/eddystone/raw/master/branding/"
  name "Chalet"
  desc "Chalet font family"
  homepage "https://houseind.com/hi/chalet"

  font "Chalet/Chalet-LondonEighty.otf"
  font "Chalet/Chalet-LondonSeventy.otf"
  font "Chalet/Chalet-LondonSixty.otf"
  font "Chalet/Chalet-NewYorkEighty.otf"
  font "Chalet/Chalet-NewYorkSeventy.otf"
  font "Chalet/Chalet-NewYorkSixty.otf"
  font "Chalet/Chalet-ParisEighty.otf"
  font "Chalet/Chalet-ParisSeventy.otf"
  font "Chalet/Chalet-ParisSixty.otf"
  font "Chalet/Chalet-Tokyo.otf"
end