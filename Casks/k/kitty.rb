cask "kitty" do
  version "0.34.0"
  sha256 "8de3cf864db4e9522e49129147fb296ebee114e976740cdd90aad09738844048"

  url "https:github.comkovidgoyalkittyreleasesdownloadv#{version}kitty-#{version}.dmg"
  name "kitty"
  desc "GPU-based terminal emulator"
  homepage "https:github.comkovidgoyalkitty"

  depends_on macos: ">= :sierra"

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