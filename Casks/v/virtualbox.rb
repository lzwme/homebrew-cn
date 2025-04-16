cask "virtualbox" do
  arch arm: "macOSArm64", intel: "OSX"

  version "7.1.8,168469"
  sha256 arm:   "2605062f1b60f45210b54ff22b7f8d2109bbf50c9dbff807919f15bbfca92021",
         intel: "a01b8ca7dd30f23c3527a68347b923bade2171ad8ab5b3e8e7ae008876a33505"

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