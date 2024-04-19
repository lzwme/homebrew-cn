cask "gqrx" do
  version "2.17.5"
  sha256 "b69af85c295dd5f1a944b389127f088d28cb4bfaf281904d7e3698c034cf0616"

  url "https:github.comgqrx-sdrgqrxreleasesdownloadv#{version.major_minor_patch}Gqrx-#{version}.dmg",
      verified: "github.comgqrx-sdrgqrx"
  name "Gqrx"
  desc "Software-defined radio receiver powered by GNU Radio and Qt"
  homepage "https:gqrx.dk"

  depends_on macos: ">= :catalina"

  app "Gqrx.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}gqrx.wrapper.sh"
  binary shimscript, target: "gqrx"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      '#{appdir}Gqrx.appContentsMacOSgqrx' "$@"
    EOS
  end

  zap trash: "~.configgqrx"
end