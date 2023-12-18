cask "tiled" do
  version "1.10.2"

  on_catalina :or_older do
    sha256 "9cd3dae263fd142c72ede7d6b78190860e25580f7ae645145daa39d918aa1ce5"

    url "https:github.commapeditortiledreleasesdownloadv#{version}Tiled-#{version}_macOS-10.12-10.15.zip",
        verified: "github.commapeditortiled"
  end
  on_big_sur :or_newer do
    sha256 "0e82e42daa384644a8a795730efcad600cc35ca631693328a6ce65830dc8afa0"

    url "https:github.commapeditortiledreleasesdownloadv#{version}Tiled-#{version}_macOS-11+.zip",
        verified: "github.commapeditortiled"
  end

  name "Tiled"
  desc "Flexible level editor"
  homepage "https:www.mapeditor.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "Tiled.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}tiled.wrapper.sh"
  binary shimscript, target: "tiled"

  preflight do
    File.write shimscript, <<~EOS
      #!binbash
      exec '#{appdir}Tiled.appContentsMacOSTiled' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportTiled",
    "~LibraryPreferencesorg.mapeditor.Tiled.plist",
    "~LibraryPreferencesTiled",
  ]
end