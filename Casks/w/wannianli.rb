cask "wannianli" do
  version "2019-12-06"
  sha256 "702298f34ca2576a02388a4103fc0e09a4aae753df21ca2e012f6f87497db6e9"

  url "https:github.comzfdangchinese-lunar-calendar-for-macreleasesdownload#{version}WanNianLi.app-v#{version.no_hyphens}.zip"
  name "WanNianLi"
  desc "Chinese lunar calendar on the menu bar"
  homepage "https:github.comzfdangchinese-lunar-calendar-for-mac"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :el_capitan"

  app "WanNianLi.app"

  zap trash: "~LibraryApplication Supportcom.zfdang.calendar"

  caveats do
    requires_rosetta
  end
end