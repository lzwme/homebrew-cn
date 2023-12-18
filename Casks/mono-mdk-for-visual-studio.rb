cask "mono-mdk-for-visual-studio" do
  version "6.12.0.199"
  sha256 "65d755bdc7d0b017ddaa211544f0d89a7836c5e3549c63fe5c2fb8f69c649489"

  url "https:download.mono-project.comarchive#{version.major_minor_patch}macos-10-universalMonoFramework-MDK-#{version}.macos10.xamarin.universal.pkg"
  name "Mono"
  desc "Open source implementation of Microsoft's .NET Framework"
  homepage "https:www.mono-project.com"

  # The stable version is that listed on the download page. See:
  #   https:github.comHomebrewhomebrew-cask-versionspull12974
  livecheck do
    url "https:www.mono-project.comdownloadvs#download-mac"
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