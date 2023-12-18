cask "virtualbox6" do
  version "6.1.48,159471"
  sha256 "a57276cc7d649acf7a65936f499020f7d1d73d66c8c8c83f6681fde09ceb4c81"

  url "https:download.virtualbox.orgvirtualbox#{version.csv.first}VirtualBox-#{version.csv.first}-#{version.csv.second}-OSX.dmg"
  name "Oracle VirtualBox"
  desc "Virtualizer for x86 hardware"
  homepage "https:www.virtualbox.org"

  livecheck do
    url "https:www.virtualbox.orgwikiDownload_Old_Builds_6_1"
    regex(href=.*?VirtualBox-(\d+(?:\.\d+)+)-(\d+)-OSX.dmgi)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  conflicts_with cask: "homebrewcask-versionsvirtualbox-beta"
  depends_on macos: ">= :high_sierra"
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

  caveats do
    kext
  end
end