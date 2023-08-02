cask "letsview" do
  version "1.1.0"
  sha256 :no_check

  url "https://download.aoscdn.com/down.php?softid=letsview", user_agent: "Macintosh",
                                                              verified:   "download.aoscdn.com/"
  name "LetsView"
  desc "Turn a computer into an Airplay display"
  homepage "https://letsview.com/mac"

  pkg "letsview.pkg"

  uninstall pkgutil: [
    "MacLetsView.apowersoft.com",
    "MacLetsView.wangxutech.com",
  ]
end