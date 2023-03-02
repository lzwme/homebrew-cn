require_relative "../lib/b2_download_strategy" unless defined?(B2DownloadStrategy)

cask "font-quebec-serial" do
  version "1.0"
  sha256 "351871cbc4530bc2653d0d0b45afae911430880a93f97cc1ea7a50471efb365e"

  url "b2://backblazeb2.com/brewery/fonts/quebec-serial.zip",
      verified: "backblazeb2.com/brewery/"
  name "Quebec Serial"
  desc "Quebec Serial font family"
  homepage "https://github.com/codello/homebrew-brewery/"

  font "quebec-serial-black-regular.ttf"
  font "quebec-serial-bold.ttf"
  font "quebec-serial-extrabold-regular.ttf"
  font "quebec-serial-heavy-regular.ttf"
  font "quebec-serial-light-regular.ttf"
  font "quebec-serial-medium-regular.ttf"
  font "quebec-serial-regulardb.ttf"
end