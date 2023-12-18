cask "scribus" do
  version "1.5.8"
  sha256 "d5ebc6f104bb57457c68ce651864053040af38f218bad1eef17491db7e6282ef"

  url "https:downloads.sourceforge.netscribusscribus-devel#{version}scribus-#{version}.dmg",
      verified: "sourceforge.netscribus"
  name "Scribus"
  desc "Free and open-source page layout program"
  homepage "https:www.scribus.net"

  # The stable branch is outdated and supported on deprecated versions of MacOS.
  # Use the devel branch until the stable branch is updated
  # https:github.comHomebrewhomebrew-caskpull120289
  livecheck do
    url "https:www.scribus.netdownloads"
    regex(%r{href=.*?scribus[._-]develv?(\d+(?:\.\d+)+)}i)
  end

  app "Scribus.app"

  zap trash: [
    "~LibraryApplication SupportScribus",
    "~LibraryPreferencesScribus",
    "~LibrarySaved Application Statenet.scribus.savedState",
  ]
end