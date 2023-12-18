cask "copyq" do
  on_catalina :or_older do
    version "5.0.0"
    sha256 "7201ff51d1258c8eae03580262a96bbee7d65c6e2133b0d5d6f10f95f031edd4"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "7.1.0"
    sha256 "f1d61f1194922393471975c0f8accf83ad58ed9ea77b3a342a771e7778f74d15"
  end

  url "https:github.comhlukCopyQreleasesdownloadv#{version}CopyQ.dmg.zip",
      verified: "github.comhlukCopyQ"
  name "CopyQ"
  desc "Clipboard manager with advanced features"
  homepage "https:hluk.github.ioCopyQ"

  app "CopyQ.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}copyq.wrapper.sh"
  binary shimscript, target: "copyq"

  preflight do
    File.write shimscript, <<~EOS
      #!binbash
      exec '#{appdir}CopyQ.appContentsMacOSCopyQ' "$@"
    EOS
  end

  zap trash: [
    "~.configcopyq",
    "~LibraryApplication Supportcopyq",
    "~LibraryApplication Supportcopyq.log",
    "~LibraryPreferencescom.copyq.copyq.plist",
  ]

  caveats do
    unsigned_accessibility
  end
end