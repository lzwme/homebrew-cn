cask "mono-mdk-for-visual-studio" do
  version "6.12.0.205"
  sha256 "c56f386eeff8e28898313fea97e09af078f8fcefaeb7af1bf69e4261f643cd88"

  url "https:download.mono-project.comarchive#{version.major_minor_patch}macos-10-universalMonoFramework-MDK-#{version}.macos10.xamarin.universal.pkg"
  name "Mono"
  desc "Open source implementation of Microsoft's .NET Framework"
  homepage "https:www.mono-project.com"

  # The stable version is that listed on the download page. See:
  #   https:github.comHomebrewhomebrew-cask-versionspull12974
  livecheck do
    url "https:www.mono-project.comdownloadpreview"
    regex(MonoFramework-MDK-(\d+(?:\.\d+)+).macos10.xamarin.universal\.pkgi)
  end

  conflicts_with cask:    "mono-mdk",
                 formula: "mono"

  pkg "MonoFramework-MDK-#{version}.macos10.xamarin.universal.pkg"

  uninstall delete:  [
              "LibraryFrameworksMono.frameworkVersions#{version.major_minor_patch}",
              "privateetcpaths.dmono-commands",
            ],
            pkgutil: "com.xamarin.mono-*",
            rmdir:   [
              "LibraryFrameworksMono.frameworkVersions",
              "LibraryFrameworksMono.framework",
            ]

  zap trash:  [
        "~.mono",
        "~LibraryCachescom.xamarin.fontconfig",
      ],
      delete: "~LibraryPreferencesmono-sgen64.plist"

  caveats <<~EOS
    This is a version specific for Visual Studio users. This cask should follow the specific Visual Studio channelbranch maintained by mono developers.

    Installing #{token} removes mono and mono dependant formula binaries in
    usrlocalbin and adds #{token} to privateetcpaths.d
    You may want to:

      brew unlink {formula} && brew link {formula}

    andor remove privateetcpaths.dmono-commands
  EOS
end