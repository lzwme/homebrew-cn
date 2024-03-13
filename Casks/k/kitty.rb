cask "kitty" do
  version "0.33.0"
  sha256 "c9dd9ee4cbece3d172488a4d5f1dd61df83f4ff559de7adf4a35e17c5cf7b6c5"

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