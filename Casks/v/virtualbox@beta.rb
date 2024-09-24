cask "virtualbox@beta" do
  arch arm: "macOSArm64", intel: "OSX"

  on_arm do
    version "7.0.21_BETA4-164889"
    sha256 "80b11ece29837c044f72eb89632d84f95fcfba6791772692641a5d7f2ea29f41"
  end
  on_intel do
    version "7.0.21-164889"
    sha256 "3c85cfd6c8eeb49a2660e8be9f7c45e8e3233ebc4d253c891fb40a9fe03a127f"
  end

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