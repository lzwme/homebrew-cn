cask "bing-wallpaper" do
  version "1.1.5"
  sha256 "c3e9d7ccccabb58df1c2f9671241198bdb5b3b2038b23898d6550ae41f98d8f8"

  url "https://download.microsoft.com/download/a/b/9/ab92b51f-92ea-4d46-9d21-9446bd20eed8/Mac/Installer/#{version}/Bing/Flight1/MW011/Defaults/Bing%20Wallpaper.pkg"
  name "Bing Wallpaper"
  desc "Use the Bing daily image as your wallpaper"
  homepage "https://bingwallpaper.microsoft.com/"

  livecheck do
    url "https://go.microsoft.com/fwlink/?linkid=2181295&installerType=PKG"
    regex(%r{Installer/(\d+(?:\.\d+)+)[^/]*/}i)
    strategy :header_match
  end

  depends_on macos: ">= :big_sur"

  pkg "Bing Wallpaper.pkg"

  uninstall launchctl: [
              "com.microsoft.msbwapp",
              "com.microsoft.msbwupdater",
            ],
            quit:      [
              "com.microsoft.autoupdate2",
              "com.microsoft.MicrosoftBingSearch",
              "com.microsoft.msbwapp",
              "com.microsoft.msbwdefaults",
            ],
            pkgutil:   "com.microsoft.msbwpackage"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.msbwdefaults.sfl*",
    "~/Library/Application Support/Microsoft/Bing Wallpaper",
  ]

  caveats do
    requires_rosetta
  end
end