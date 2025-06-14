cask "apptrap" do
  version "1.2.3"
  sha256 "39a8923698c2e1a38ff3fd7fc2c12b7a847566cf1f31f965d0fb57e2280aaa5c"

  url "http://onnati.net/apptrap/download/AppTrap#{version.dots_to_hyphens}.zip"
  name "AppTrap"
  homepage "http://onnati.net/apptrap/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-11-02", because: :unmaintained

  prefpane "AppTrap.prefPane"

  uninstall login_item: "AppTrap"

  zap trash: "~/Library/Preferences/com.KumaranVijayan.AppTrap.prefpanel.plist"

  caveats do
    requires_rosetta
  end
end