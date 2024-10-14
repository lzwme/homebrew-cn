cask "qutebrowser" do
  arch arm: "arm64", intel: "x86_64"

  version "3.3.1"
  sha256 arm:   "d3d134c184bf12c8d1139eac0caea240138652c09d18acd3ff8018faac64aa89",
         intel: "731126006977134e5281f5abc02513127022ae7aca92ccf5c8c2b487683f89d4"

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