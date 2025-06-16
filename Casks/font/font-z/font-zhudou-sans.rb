cask "font-zhudou-sans" do
  version "2.000"
  sha256 "1a2718aa52c98d1ac7e18d60e0f1d61057b18e558e8196a3a770104855a6fc69"

  url "https:github.comBuerniaZhudou-Sansreleasesdownloadv#{version}Zhudou.Sans.zip"
  name "Zhudou Sans"
  name "煮豆黑体"
  homepage "https:github.comBuerniaZhudou-Sans"

  no_autobump! because: :requires_manual_review

  font "otfZhudouSans-Bold.otf"
  font "otfZhudouSans-ExtraLight.otf"
  font "otfZhudouSans-Heavy.otf"
  font "otfZhudouSans-Light.otf"
  font "otfZhudouSans-Medium.otf"
  font "otfZhudouSans-Normal.otf"
  font "otfZhudouSans-Regular.otf"

  # No zap stanza required
end