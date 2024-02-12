cask "gqrx" do
  version "2.17.4"
  sha256 "4475ba36c8a3707d29b5b5cff9260b4f234f96c5c785ab777dd493480ee150a5"

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