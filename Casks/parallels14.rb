cask "parallels14" do
  version "14.1.3-45485"
  sha256 "34c9c345642fa30f9d240a76062c5672e399349d5e5984db9c208d22e099f8b9"

  url "https:download.parallels.comdesktopv#{version.major}#{version}ParallelsDesktop-#{version}.dmg"
  name "Parallels Desktop"
  desc "Desktop virtualization software"
  homepage "https:www.parallels.comproductsdesktop"

  livecheck do
    url "https:kb.parallels.com124521"
    regex((\d+(?:\.\d+)+)(?:\s*|&nbsp;)\((\d+)\)i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]}-#{match[1]}" }
    end
  end

  auto_updates true
  conflicts_with cask: [
    "parallels",
    "homebrewcask-versionsparallels12",
    "homebrewcask-versionsparallels13",
    "homebrewcask-versionsparallels15",
    "homebrewcask-versionsparallels16",
    "homebrewcask-versionsparallels17",
    "homebrewcask-versionsparallels18",
  ]
  depends_on macos: [
    :el_capitan,
    :sierra,
    :high_sierra,
    :mojave,
  ]
  # This .dmg cannot be extracted normally
  # Original discussion: https:github.comHomebrewhomebrew-caskpull67202
  container type: :naked

  preflight do
    system_command "usrbinhdiutil",
                   args: ["attach", "-nobrowse", "#{staged_path}ParallelsDesktop-#{version}.dmg"]
    system_command "VolumesParallels Desktop #{version.major}Parallels Desktop.appContentsMacOSinittool",
                   args: ["install", "-t", "#{appdir}Parallels Desktop.app", "-s"],
                   sudo: true
    system_command "usrbinhdiutil",
                   args: ["detach", "VolumesParallels Desktop #{version.major}"]
  end

  postflight do
    # Unhide the application
    system_command "usrbinchflags",
                   args: ["nohidden", "#{appdir}Parallels Desktop.app"],
                   sudo: true

    # Run the initialization script
    system_command "#{appdir}Parallels Desktop.appContentsMacOSinittool",
                   args: ["init", "-b", "#{appdir}Parallels Desktop.app"],
                   sudo: true
  end

  uninstall_preflight do
    set_ownership "#{appdir}Parallels Desktop.app"
  end

  uninstall delete: [
    "ApplicationsParallels Desktop.app",
    "ApplicationsParallels Desktop.appContentsApplicationsParallels Link.app",
    "ApplicationsParallels Desktop.appContentsApplicationsParallels Mounter.app",
    "ApplicationsParallels Desktop.appContentsApplicationsParallels Technical Data Reporter.app",
    "ApplicationsParallels Desktop.appContentsMacOSParallels Service.app",
    "ApplicationsParallels Desktop.appContentsMacOSParallels VM.app",
    "usrlocalbinprl_convert",
    "usrlocalbinprl_disk_tool",
    "usrlocalbinprl_perf_ctl",
    "usrlocalbinprlcore2dmp",
    "usrlocalbinprlctl",
    "usrlocalbinprlexec",
    "usrlocalbinprlsrvctl",
  ]

  zap trash: [
    "~.parallels_settings",
    "~LibraryCachescom.parallels.desktop.console",
    "~LibraryPreferencescom.parallels.desktop.console.LSSharedFileList.plist",
    "~LibraryPreferencescom.parallels.desktop.console.plist",
    "~LibraryPreferencescom.parallels.Parallels Desktop Statistics.plist",
    "~LibraryPreferencescom.parallels.Parallels Desktop.plist",
    "~LibraryPreferencescom.parallels.Parallels.plist",
  ]
end