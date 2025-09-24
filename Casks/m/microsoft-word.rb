cask "microsoft-word" do
  on_monterey :or_older do
    on_catalina :or_older do
      version "16.66.22101101"
      sha256 "5a6a75d9a5b46cceeff5a1b7925c0eab6e4976cba529149b7b291a0355e7a7c9"
    end
    on_big_sur do
      version "16.77.23091703"
      sha256 "10c8db978206275a557faf3650763a656b1f7170c9b2a65fa6fdce220bd23066"
    end
    on_monterey do
      version "16.89.24091630"
      sha256 "e064013cf26dc3742f07436fae1bb1a37fdd21fc4fb09640c0de0fc977f4ffd3"
    end

    livecheck do
      skip "Legacy version"
    end
  end
  on_ventura :or_newer do
    version "16.101.25092124"
    sha256 "410727fc2169b83a8da8e700fa8c0906f0879e8a64b24cf6c03c355556174696"

    livecheck do
      url "https://go.microsoft.com/fwlink/p/?linkid=525134"
      strategy :header_match
    end
  end

  url "https://officecdnmac.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_Word_#{version}_Installer.pkg"
  name "Microsoft Word"
  desc "Word processor"
  homepage "https://www.microsoft.com/en-US/microsoft-365/word"

  auto_updates true
  conflicts_with cask: [
    "microsoft-office",
    "microsoft-office-businesspro",
  ]
  depends_on cask: "microsoft-auto-update"

  pkg "Microsoft_Word_#{version}_Installer.pkg",
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
              "com.microsoft.package.Microsoft_Word.app",
              "com.microsoft.pkg.licensing",
            ]

  zap trash: [
    "~/Library/Application Scripts/com.microsoft.Word*",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.word.sfl*",
    "~/Library/Application Support/CrashReporter/Microsoft Word_*.plist",
    "~/Library/Application Support/Microsoft",
    "~/Library/Containers/com.microsoft.Word*",
    "~/Library/Group Containers/UBF8T346G9.ms/Microsoft Word.MERP.params.txt",
    "~/Library/Preferences/com.microsoft.Word.plist",
    "~/Library/Saved Application State/com.microsoft.Word.savedState",
  ]
end