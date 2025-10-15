cask "microsoft-powerpoint" do
  on_monterey :or_older do
    on_catalina :or_older do
      version "16.66.22101101"
      sha256 "bea8c4790445f726debd0f64d24fbdac59e3a9b51e95c092fb31da3913164540"
    end
    on_big_sur do
      version "16.77.23091703"
      sha256 "9ece350fa314584aafacfcdf559bb67b8707bc2c2e7a961f7881d1ea280aac4d"
    end
    on_monterey do
      version "16.89.24091630"
      sha256 "44801ae2e12318f6f8982da6fabb1c7c1d79fb38cc464fecfd60189aa36e9555"
    end

    livecheck do
      skip "Legacy version"
    end
  end
  on_ventura :or_newer do
    version "16.102.25101223"
    sha256 "d0fdd2d22bc9cc23c5aa6e4490f07c2a51da41ad4e1c1b6e09a6df528831409d"

    livecheck do
      url "https://go.microsoft.com/fwlink/p/?linkid=525136"
      strategy :header_match
    end
  end

  url "https://officecdnmac.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_PowerPoint_#{version}_Installer.pkg"
  name "Microsoft PowerPoint"
  desc "Presentation software"
  homepage "https://www.microsoft.com/en-US/microsoft-365/powerpoint"

  auto_updates true
  conflicts_with cask: [
    "microsoft-office",
    "microsoft-office-businesspro",
  ]
  depends_on cask: "microsoft-auto-update"

  pkg "Microsoft_PowerPoint_#{version}_Installer.pkg",
      choices: [
        {
          "choiceIdentifier" => "com.microsoft.autoupdate", # Office16_all_autoupdate.pkg
          "choiceAttribute"  => "selected",
          "attributeSetting" => 0,
        },
      ]

  uninstall launchctl: "com.microsoft.office.licensingV2.helper",
            quit:      "com.microsoft.autoupdate2",
            pkgutil:   [
              "com.microsoft.package.Microsoft_PowerPoint.app",
              "com.microsoft.pkg.licensing",
            ],
            delete:    "/Applications/Microsoft PowerPoint.app"

  zap trash: [
    "~/Library/Application Scripts/com.microsoft.Powerpoint*",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.powerpoint.sfl*",
    "~/Library/Containers/com.microsoft.Powerpoint*",
    "~/Library/Preferences/com.microsoft.Powerpoint.plist",
    "~/Library/Saved Application State/com.microsoft.Powerpoint.savedState",
  ]
end