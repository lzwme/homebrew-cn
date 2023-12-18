cask "parallels-access" do
  version "7.0.5-40851"
  sha256 "663ee5e79e1cace49baf217b2fba61cdbd0746a920dca589520accf545afdce9"

  url "https:download.parallels.compmobilev#{version.major}#{version}ParallelsAccess-#{version}-mac.dmg"
  name "Parallels Access"
  desc "Simplest remote access to your computer from anywhere"
  homepage "https:www.parallels.comproductsaccess"

  livecheck do
    url "https:download.parallels.comwebsite_linkspmobile3builds-en_US.json"
    strategy :page_match do |page|
      scan = page.scan(ParallelsAccess[._-]v?(\d+(?:\.\d+)+)-(\d+)[._-]mac\.dmgi)
      scan.map { |v| "#{v[0]}-#{v[1]}" }
    end
  end

  # This .dmg cannot be extracted normally
  # Original discussion: https:github.comHomebrewhomebrew-caskissues26872
  container type: :naked

  preflight do
    system_command "usrbinhdiutil",
                   args: ["attach", "-nobrowse", "#{staged_path}ParallelsAccess-#{version}-mac.dmg"]
    system_command "VolumesParallels AccessParallels Access.appContentsMacOSpm_ctl",
                   args: ["instance_install"],
                   sudo: true
    system_command "usrbinhdiutil",
                   args: ["detach", "VolumesParallels Access"]
  end

  uninstall launchctl: [
              "com.parallels.mobile.audioloader",
              "com.parallels.mobile.dispatcher.launchdaemon",
              "com.parallels.mobile.kextloader.launchdaemon",
              "com.parallels.mobile.prl_deskctl_agent.launchagent",
              "com.parallels.mobile.startgui.launchagent",
            ],
            quit:      "com.parallels.inputmethod.ParallelsIM",
            signal:    [
              ["TERM", "com.parallels.mobile"],
              ["TERM", "com.parallels.mobile.prl_deskctl_agent"],
            ],
            kext:      [
              "com.parallels.virtualhid",
              "com.parallels.virtualsound",
            ],
            delete:    "ApplicationsParallels Access.app"

  zap trash: [
    "~LibraryCookiescom.parallels.mobile.prl_deskctl_agent.binarycookies",
    "~LibraryGroup Containers4C6364ACXT.com.parallels.Access",
    "~LibraryPreferencescom.parallels.mobile.plist",
    "~LibraryPreferencescom.parallels.Parallels Access.plist.sdb",
    "~LibraryPreferencescom.parallels.Parallels Access.plist",
  ]
end