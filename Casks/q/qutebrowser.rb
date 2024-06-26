cask "qutebrowser" do
  arch arm: "arm64", intel: "x86_64"

  version "3.2.1"
  sha256 arm:   "1cd1172d7cb5ae01e20fdec9c8e12e06e6407868e07b5c2f1e0a3d7ac6592826",
         intel: "98eb70379e37e4ee5e664e7c99f1dad1e5b618d00cd50595b46a17cfd29a071a"

  url "https:github.comqutebrowserqutebrowserreleasesdownloadv#{version}qutebrowser-#{version}-#{arch}.dmg",
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
end