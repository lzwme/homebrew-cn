require_relative "..libb2_download_strategy" unless defined?(B2DownloadStrategy)

cask "font-quebec-serial" do
  version "1.0"
  sha256 :no_check

  url "b2:backblazeb2.combreweryfontsquebec-serial.zip",
      verified: "backblazeb2.combrewery"
  name "Quebec Serial"
  desc "Quebec Serial font family"
  homepage "https:github.comcodellohomebrew-brewery"

  font "quebec-serial-black-regular.ttf"
  font "quebec-serial-bold.ttf"
  font "quebec-serial-extrabold-regular.ttf"
  font "quebec-serial-heavy-regular.ttf"
  font "quebec-serial-light-regular.ttf"
  font "quebec-serial-medium-regular.ttf"
  font "quebec-serial-regulardb.ttf"
end