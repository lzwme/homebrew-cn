cask "kitty" do
  version "0.31.0"
  sha256 "8ea20b4d90b480bca6ec08c5492f5bcda1c55c5619879278751af5a4034bb91a"

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