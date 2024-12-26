cask "goneovim" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.11"
  sha256 arm:   "425615de46b6675ee92c7d435d80a4063c391983dfa9dc0c40aaefdb1af7870d",
         intel: "aed61b45da5cb38c466762542c722c1d36ac1317d97c59b544c0e0f64dbbf326"

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