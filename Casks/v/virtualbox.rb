cask "virtualbox" do
  version "7.0.14,161095"
  sha256 "879ba6aa488dc2a086d45d98174d6928de59a5fa575a895ead3c872e5f7c0b76"

  url "https:download.virtualbox.orgvirtualbox#{version.csv.first}VirtualBox-#{version.csv.first}-#{version.csv.second}-OSX.dmg"
  name "Oracle VirtualBox"
  desc "Virtualiser for x86 hardware"
  homepage "https:www.virtualbox.org"

  livecheck do
    url "https:www.virtualbox.orgwikiDownloads"
    strategy :page_match do |page|
      match = page.match(href=.*?VirtualBox-(\d+(?:\.\d+)+)-(\d+)-OSX.dmg)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  conflicts_with cask: "homebrewcask-versionsvirtualbox-beta"
  depends_on macos: ">= :catalina"
  depends_on arch: :x86_64

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