cask "devtoys" do
  version "0.0.11"
  sha256 "84f6b354546b1731204deb48daed53caacab277b524bcdd8d5e47d53fc47b413"

  url "https:github.comObuchiYukiDevToysMacreleasesdownload#{version}DevToys.app.zip"
  name "DevToys"
  desc "Utilities designed to make common development tasks easier"
  homepage "https:github.comObuchiYukiDevToysMac"

  depends_on macos: ">= :catalina"

  app "DevToys.app"

  zap trash: "~LibraryPreferencescom.yuki.DevToys.plist"
end