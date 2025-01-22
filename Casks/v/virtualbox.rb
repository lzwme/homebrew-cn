cask "virtualbox" do
  arch arm: "macOSArm64", intel: "OSX"

  version "7.1.6,167084"
  sha256 arm:   "f46db4a00d7cc72c50696cfd86c2f90bd3a4727bddd41a5e6b21a1ae07c32547",
         intel: "73f7f088c1c098e9f5fbddc6cb1a0d7b56b9a500a1f34db0bee4c07ec06064b4"

  url "https:download.virtualbox.orgvirtualbox#{version.csv.first}VirtualBox-#{version.csv.first}-#{version.csv.second}-#{arch}.dmg"
  name "Oracle VirtualBox"
  desc "Virtualiser for x86 hardware"
  homepage "https:www.virtualbox.org"

  livecheck do
    url "https:www.virtualbox.orgwikiDownloads"
    regex(href=.*?VirtualBox[._-]v?(\d+(?:\.\d+)+)[._-](\d+)[._-]OSX\.dmgi)
    strategy :page_match do |page, regex|
      match = page.match(regex)
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