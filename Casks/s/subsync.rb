cask "subsync" do
  version "0.17.0"
  sha256 "8d81f4d8da99b5f6b023da3fd100fccadb0c2b07143e495eb57bd22bfa5a78bd"

  url "https:github.comsc0tysubsyncreleasesdownload#{version.major_minor}subsync-#{version}-mac-x86_64.dmg",
      verified: "github.comsc0tysubsync"
  name "subsync"
  desc "Subtitle speech synchroniser"
  homepage "https:subsync.online"

  livecheck do
    url "https:subsync.onlineendownload.html"
    regex(%r{href=.*?subsync[._-]v?(\d+(?:\.\d+)+)-mac-x86_64\.dmg}i)
  end

  app "subsync.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}subsync.wrapper.sh"
  binary shimscript, target: "subsync"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}subsync.appContentsMacOSsubsync' --cli "$@"
    EOS
  end

  zap trash: "~LibraryPreferencessubsync"
end