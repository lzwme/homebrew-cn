cask "windows-app" do
  version "11.0.1"
  sha256 "8c53f6bc8f863c984967193c4f7572be80e0154cf90aa2db22303edcc3172faa"

  url "https://officecdnmac.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Windows_App_#{version}_installer.pkg",
      verified: "officecdnmac.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/"
  name "Windows App"
  desc "Connect to Windows"
  homepage "https://aka.ms/WindowsApp"

  livecheck do
    url "https://go.microsoft.com/fwlink/?linkid=868963"
    strategy :header_match
  end

  auto_updates true
  conflicts_with cask: "microsoft-remote-desktop"
  depends_on macos: ">= :monterey"

  pkg "Windows_App_#{version}_installer.pkg"

  uninstall launchctl: [
              "com.microsoft.autoupdate.helper",
              "com.microsoft.update.agent",
            ],
            quit:      [
              "com.microsoft.autoupdate.fba",
              "com.microsoft.autoupdate2",
              "com.microsoft.errorreporting",
            ],
            pkgutil:   [
              "com.microsoft.package.Microsoft_AutoUpdate.app",
              "com.microsoft.rdc.macos",
            ]

  zap trash: [
    "~/Library/Application Scripts/com.microsoft.rdc.macos",
    "~/Library/Containers/com.microsoft.rdc.macos",
    "~/Library/Group Containers/UBF8T346G9.com.microsoft.rdc",
  ]
end