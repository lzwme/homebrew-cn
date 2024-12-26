cask "vlc@nightly" do
  arch arm: "arm64", intel: "x86_64"
  livecheck_arch = on_arch_conditional arm: "-arm64", intel: "-intel64"

  on_arm do
    version "4.0.0,20241225-0414,1e70019a"
    sha256 "2af0a007b1628afb498de7663dceba26306d03e6b51f6409a9f9e8b12918496c"

    url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}#{version.csv.second}vlc-#{version.csv.first}-dev-arm64-#{version.csv.third}.dmg"
  end
  on_intel do
    version "4.0.0,20241225-0415,1e70019a"
    sha256 "58b1ac5c1b8f12a17540198e897e8e54b626125609df99702bf5584a143a7064"

    url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}#{version.csv.second}vlc-#{version.csv.first}-dev-intel64-#{version.csv.third}.dmg"
  end

  name "VLC media player"
  desc "Open-source cross-platform multimedia player"
  homepage "https:www.videolan.orgvlc"

  livecheck do
    url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}"
    regex(href=.*?vlc[._-]v?(\d+(?:\.\d+)+)-dev#{livecheck_arch}-(\h+)\.dmgi)
    strategy :page_match do |page, regex|
      directory = page.scan(%r{href=["']?v?(\d+(?:[.-]\d+)+)?["' >]}i)
                      .flatten
                      .uniq
                      .max
      next if directory.blank?

      # Fetch the directory listing page for newest build
      build_response = Homebrew::Livecheck::Strategy.page_content(
        "https:artifacts.videolan.orgvlcnightly-macos-#{arch}#{directory}",
      )
      next if (build_page = build_response[:content]).blank?

      match = build_page.match(regex)
      next if match.blank?

      "#{match[1]},#{directory},#{match[2]}"
    end
  end

  deprecate! date: "2025-05-01", because: :unsigned

  conflicts_with cask: "vlc"

  app "VLC.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}vlc.wrapper.sh"
  binary shimscript, target: "vlc"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}VLC.appContentsMacOSVLC' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.videolan.vlc.sfl*",
    "~LibraryApplication Supportorg.videolan.vlc",
    "~LibraryApplication SupportVLC",
    "~LibraryCachesorg.videolan.vlc",
    "~LibraryPreferencesorg.videolan.vlc",
    "~LibraryPreferencesorg.videolan.vlc.plist",
    "~LibrarySaved Application Stateorg.videolan.vlc.savedState",
  ]
end