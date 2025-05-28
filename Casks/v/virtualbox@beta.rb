cask "virtualbox@beta" do
  arch arm: "macOSArm64", intel: "OSX"

  version "7.1.9-169012"
  sha256 arm:   "1775a1ac2d57dd6a44603d8a1c4ed621f01d0673104d0ff152cb8f94a95537d8",
         intel: "bb92a519747bd312d83a09e3c1cc3254c5aed8bb8132e5c4fa1b2134b60618d2"

  url "https:www.virtualbox.orgdownloadtestcaseVirtualBox-#{version}-#{arch}.dmg"
  name "Oracle VirtualBox"
  desc "Virtualizer for x86 and arm64 hardware"
  homepage "https:www.virtualbox.orgwikiTestbuilds"

  livecheck do
    url :homepage
    regex(href=.*?VirtualBox[._-]v?(\d+(?:[.-]\d+)+.*?)[._-]#{arch}\.dmg(?!.+?development)i)
  end

  conflicts_with cask: [
    "virtualbox",
    "virtualbox@6",
  ]
  depends_on macos: ">= :catalina"

  pkg "VirtualBox.pkg",
      choices: [
        {
          "choiceIdentifier" => "choiceVBoxKEXTs",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 1,
        },
        {
          "choiceIdentifier" => "choiceVBox",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 1,
        },
        {
          "choiceIdentifier" => "choiceVBoxCLI",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 1,
        },
        {
          "choiceIdentifier" => "choiceOSXFuseCore",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 0,
        },
      ]

  postflight do
    # If VirtualBox is installed before `usrlocallibpkgconfig` is created by Homebrew,
    # it creates it itself with incorrect permissions that break other packages.
    # See https:github.comHomebrewhomebrew-caskissues68730#issuecomment-534363026
    set_ownership "usrlocallibpkgconfig"
  end

  uninstall script:  {
              executable: "VirtualBox_Uninstall.tool",
              args:       ["--unattended"],
              sudo:       true,
            },
            pkgutil: "org.virtualbox.pkg.*",
            delete:  "usrlocalbinvboximg-mount"

  zap trash: [
        "LibraryApplication SupportVirtualBox",
        "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.virtualbox.app.virtualbox.sfl*",
        "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.virtualbox.app.virtualboxvm.sfl*",
        "~LibraryPreferencesorg.virtualbox.app.VirtualBox.plist",
        "~LibraryPreferencesorg.virtualbox.app.VirtualBoxVM.plist",
        "~LibrarySaved Application Stateorg.virtualbox.app.VirtualBox.savedState",
        "~LibrarySaved Application Stateorg.virtualbox.app.VirtualBoxVM.savedState",
        "~LibraryVirtualBox",
      ],
      rmdir: "~VirtualBox VMs"

  caveats do
    kext
  end
end