cask "qutebrowser" do
  arch arm: "arm64", intel: "x86_64"

  version "3.4.0"
  sha256 arm:   "1f9bbcabfc23c25c79a70fd2d78c157b6f931318a80fa3e0719661757a1b5ea1",
         intel: "f9490294c854f6da9015e38e6a9d7a6c35f28b6451b32915fe166b3215047dd3"

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