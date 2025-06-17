cask "goneovim" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.14"
  sha256 arm:   "2b76a7b40c7c915d40b2ac5520fa68849484ab45e322f654f3f4b032214cff44",
         intel: "a5a0d15399db2ea6fdfb264e21e2e863777edf4d8bc7793fe22f7795e3ff5a99"

  url "https:github.comakiyosigoneovimreleasesdownloadv#{version}Goneovim-v#{version}-macos-#{arch}.tar.bz2"
  name "Goneovim"
  desc "Neovim GUI written in Golang, using a Golang qt backend"
  homepage "https:github.comakiyosigoneovim"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "neovim"

  app "goneovim-v#{version}-macos-#{arch}goneovim.app"
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
    "~.goneovim",
    "~LibrarySaved Application Statecom.ident.goneovim.savedState",
  ]
end