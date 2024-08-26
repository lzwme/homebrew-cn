cask "sioyek" do
  version "2.0.0"
  sha256 "0f81831d4fa0d57e7e7e56a40ab6fa6488950b7d6a944aa29918be42cfc46b8a"

  url "https:github.comahrmsioyekreleasesdownloadv#{version}sioyek-release-mac.zip",
      verified: "github.comahrmsioyek"
  name "Sioyek"
  desc "PDF viewer designed for reading research papers and technical books"
  homepage "https:sioyek.info"

  livecheck do
    url :url
    strategy :github_latest
  end

  container nested: "buildsioyek.dmg"

  app "sioyek.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}sioyek.wrapper.sh"
  binary shimscript, target: "sioyek"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}sioyek.appContentsMacOSsioyek' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication Supportsioyek",
    "~LibrarySaved Application Statecom.yourcompany.sioyek.savedState",
  ]

  caveats do
    requires_rosetta
  end
end