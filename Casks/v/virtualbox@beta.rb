cask "virtualbox@beta" do
  arch arm: "macOSArm64", intel: "OSX"

  version "7.1.7-167431"
  sha256 arm:   "cb47e2567d4465667b5063a47413920505c4a149050c66cfc0dc96af7de85d7f",
         intel: "5e4d2cef40d59d1652195af7719706f849abc438ef27635d6ed13c7e1cd9d121"

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