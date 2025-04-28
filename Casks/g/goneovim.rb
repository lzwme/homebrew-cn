cask "goneovim" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.13"
  sha256 arm:   "cf28520f9676d94fb0372bc472566fe9068b1f24e3272dcb6bae2fa442558a1c",
         intel: "0ef42ea82512b15b0b08b7af1cc6a640ea66b5ae79abc8d3cd46c962dba16506"

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