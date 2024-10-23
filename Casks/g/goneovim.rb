cask "goneovim" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.9"
  sha256 arm:   "92f92062e13908c9d04e69a82297569ad91e4930a001af87be9308ccd5afcb08",
         intel: "27f65edc83ff8a8770877e76f5d4d11c8849a4aef461a421e4b2029bed9322f4"

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