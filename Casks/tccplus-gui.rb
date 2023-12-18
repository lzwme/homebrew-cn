cask "tccplus-gui" do
  version "1.0"
  sha256 :no_check

  url "https:github.complessbdtccplusreleasesdownload1.0tccplus.app.zip"
  name "tccplus"
  desc "Grantremove accessibility permissions to any app"
  homepage "https:github.complessbdtccplus"

  app "tccplus.app", target: "tccplus-gui.app"
end