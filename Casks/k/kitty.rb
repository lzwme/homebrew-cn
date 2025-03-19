cask "kitty" do
  version "0.40.1"
  sha256 "5dfcd0c0d91cc94e49563df05722c92805d4f8709ca03f207f8552a22d9dddd5"

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