cask "kitty" do
  version "0.38.1"
  sha256 "2971db2c2220a9f353efcc1d58d8b88462dc5a2a992adea9c051bf6e54c90e52"

  url "https:github.comkovidgoyalkittyreleasesdownloadv#{version}kitty-#{version}.dmg"
  name "kitty"
  desc "GPU-based terminal emulator"
  homepage "https:github.comkovidgoyalkitty"

  conflicts_with cask: "kitty@nightly"
  depends_on macos: ">= :big_sur"

  app "kitty.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  kitty_shimscript = "#{staged_path}kitty.wrapper.sh"
  binary kitty_shimscript, target: "kitty"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  kitten_shimscript = "#{staged_path}kitten.wrapper.sh"
  binary kitten_shimscript, target: "kitten"

  preflight do
    File.write kitty_shimscript, <<~EOS
      #!binsh
      exec '#{appdir}kitty.appContentsMacOSkitty' "$@"
    EOS
    File.write kitten_shimscript, <<~EOS
      #!binsh
      exec '#{appdir}kitty.appContentsMacOSkitten' "$@"
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