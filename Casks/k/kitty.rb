cask "kitty" do
  version "0.32.1"
  sha256 "cd575df6903410faea5cfe25a97955eaf507fc04570c0997935f3980476378b7"

  url "https:github.comkovidgoyalkittyreleasesdownloadv#{version}kitty-#{version}.dmg"
  name "kitty"
  desc "GPU-based terminal emulator"
  homepage "https:github.comkovidgoyalkitty"

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