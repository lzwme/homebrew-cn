cask "vlc@nightly" do
  arch arm: "arm64", intel: "x86_64"
  livecheck_arch = on_arch_conditional arm: "arm64", intel: "intel64"

  on_arm do
    version "4.0.0,20250130-0413,a7f92685"
    sha256 "3b4ae94308ca07fbbb73d8509b37f7781f210941381d58787b0d6f1e347689ac"
  end
  on_intel do
    version "4.0.0,20250130-0411,a7f92685"
    sha256 "f2e95b5ddb6b183dac4bc7c6a1084adbdc1f806472980a0adeb70232a4ef4f2d"
  end

  url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}#{version.csv.second}vlc-#{version.csv.first}-dev-#{livecheck_arch}-#{version.csv.third}.dmg"
  name "VLC media player"
  desc "Open-source cross-platform multimedia player"
  homepage "https:www.videolan.orgvlc"

  livecheck do
    url "https:artifacts.videolan.orgvlcnightly-macos-#{arch}"
    regex(href=.*?vlc[._-]v?(\d+(?:\.\d+)+)[._-]dev[._-]#{livecheck_arch}[._-](\h+)\.dmgi)
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