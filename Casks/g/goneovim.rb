cask "goneovim" do
  version "0.6.7"
  sha256 "71aa694f69e7b7cad11912bc66c0433468bcabea412f7426eeeb9cf6ebe64489"

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