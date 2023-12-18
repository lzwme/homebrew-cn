cask "gqrx" do
  version "2.17.3"
  sha256 "126c981aa1fa63df65f4c8545a4a2480b5da3305e06983c2bacf6e630a7732a3"

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