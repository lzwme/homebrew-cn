cask "virtualbox" do
  arch arm: "macOSArm64", intel: "OSX"

  version "7.1.0,164728"
  sha256 arm:   "5ba5d31f379aa6d35d578f67f29c175db7356b1939d7a2a478b7e9de487c33ba",
         intel: "8ce622e23913cab562b404df7c588cea6ec3205f9063437e6f97fab2982ddae0"

  url "https:download.virtualbox.orgvirtualbox#{version.csv.first}VirtualBox-#{version.csv.first}-#{version.csv.second}-#{arch}.dmg"
  name "Oracle VirtualBox"
  desc "Virtualiser for x86 hardware"
  homepage "https:www.virtualbox.org"

  livecheck do
    url "https:www.virtualbox.orgwikiDownloads"
    strategy :page_match do |page|
      match = page.match(href=.*?VirtualBox[._-]v?(\d+(?:\.\d+)+)[._-](\d+)[._-]OSX.dmg)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  conflicts_with cask: [
    "virtualbox@6",
    "virtualbox@beta",
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
    # If VirtualBox is installed before `usrlocallibpkgconfig` is created by Homebrew, it creates it itself
    # with incorrect permissions that break other packages
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
        "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.virtualbox.app.virtualbox*",
        "~LibraryPreferencesorg.virtualbox.app.VirtualBox*",
        "~LibrarySaved Application Stateorg.virtualbox.app.VirtualBox*",
        "~LibraryVirtualBox",
      ],
      rmdir: "~VirtualBox VMs"
end