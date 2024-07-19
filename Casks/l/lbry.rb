cask "lbry" do
  version "0.53.9"
  sha256 "3769997e7cdb6e563a505c5f8375325ef26fc74318aea0defde711fc5fcfee5e"

  url "https:github.comlbryiolbry-desktopreleasesdownloadv#{version}LBRY_#{version}.dmg",
      verified: "github.comlbryiolbry-desktop"
  name "LBRY Desktop"
  desc "Official client for LBRY, a decentralised file-sharing and payment network"
  homepage "https:lbry.com"

  livecheck do
    url :url
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  depends_on macos: ">= :mojave"

  app "LBRY.app"
  # shim scripts (https:github.comHomebrewhomebrew-caskissues18809)
  shim_lbrynet = "#{staged_path}lbrynet.wrapper.sh"
  shim_lbryfirst = "#{staged_path}libry-first.wrapper.sh"
  binary shim_lbrynet, target: "lbrynet"
  binary shim_lbryfirst, target: "lbry-first"

  preflight do
    File.write shim_lbrynet, <<~EOS
      #!binsh
      exec '#{appdir}LBRY.appContentsResourcesstaticdaemonlbrynet' "$@"
    EOS

    File.write shim_lbryfirst, <<~EOS
      #!binsh
      exec '#{appdir}LBRY.appContentsResourcesstaticlbry-firstlbry-first' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication Supportlbry",
    "~LibraryPreferencesio.lbry.LBRY.plist",
    "~LibrarySaved Application Stateio.lbry.LBRY.savedState",
  ]

  caveats do
    requires_rosetta
  end
end