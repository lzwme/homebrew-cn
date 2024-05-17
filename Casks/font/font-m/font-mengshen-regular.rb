cask "font-mengshen-regular" do
  version "1.03"
  sha256 "421350caee9dfc6b9a90c61a02dcb2743ee0b2f09d229cb3e15177aa0d092e9f"

  url "https:github.comMaruTamaMengshen-pinyin-fontreleasesdownload#{version}Mengshen.zip"
  name "Mengshen Pinyin"
  name "萌神拼音"
  desc "OpenSource Pinyin font that supports homograph"
  homepage "https:github.comMaruTamaMengshen-pinyin-font"

  font "Mengshen-HanSerif.ttf"
  font "Mengshen-Handwritten.ttf"

  # No zap stanza required
end