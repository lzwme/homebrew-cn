cask "qutebrowser" do
  version "3.1.0"
  sha256 "02fbaec149f131caf67a467f3b514bff8222cd5d5a4cc85736b6dfd52c0d63b5"

  url "https:github.comqutebrowserqutebrowserreleasesdownloadv#{version}qutebrowser-#{version}.dmg",
      verified: "github.comqutebrowserqutebrowser"
  name "qutebrowser"
  desc "Keyboard-driven, vim-like browser based on PyQt5"
  homepage "https:www.qutebrowser.org"

  app "qutebrowser.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}qutebrowser.wrapper.sh"
  binary shimscript, target: "qutebrowser"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      '#{appdir}qutebrowser.appContentsMacOSqutebrowser' "$@"
    EOS
  end

  zap trash: [
        "~LibraryApplication Supportqutebrowser",
        "~LibraryCachesqutebrowser",
        "~LibraryPreferencesqutebrowser",
      ],
      rmdir: "~.qutebrowser"

  caveats do
    requires_rosetta
  end
end