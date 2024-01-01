cask "goneovim" do
  version "0.6.8"
  sha256 "f2bcb700d525a3a03af0c7d65f7c2a978e37ce695631846668fbf3a771e73761"

  url "https:github.comakiyosigoneovimreleasesdownloadv#{version}Goneovim-v#{version}-macos.tar.bz2"
  name "Goneovim"
  desc "Neovim GUI written in Golang, using a Golang qt backend"
  homepage "https:github.comakiyosigoneovim"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "neovim"

  app "goneovim-v#{version}-macosgoneovim.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}goneovim.wrapper.sh"
  binary shimscript, target: "goneovim"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}goneovim.appContentsMacOSgoneovim' "$@"
    EOS
  end

  zap trash: [
    "~LibrarySaved Application Statecom.ident.goneovim.savedState",
    "~.goneovim",
  ]
end