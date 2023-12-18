cask "kitty-nightly" do
  version :latest
  sha256 :no_check

  url "https:github.comkovidgoyalkittyreleasesdownloadnightlykitty-nightly.dmg"
  name "kitty-nightly"
  desc "GPU-based terminal emulator"
  homepage "https:github.comkovidgoyalkitty"

  conflicts_with cask: "kitty"
  depends_on macos: ">= :sierra"

  app "kitty.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}kitty.wrapper.sh"
  binary shimscript, target: "kitty"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}kitty.appContentsMacOSkitty' "$@"
    EOS
  end

  zap trash: [
    "~.configkitty",
    "~LibraryCacheskitty",
    "~LibraryPreferenceskitty",
    "~LibraryPreferencesnet.kovidgoyal.kitty.plist",
    "~LibrarySaved Application Statenet.kovidgoyal.kitty.savedState",
  ]
end