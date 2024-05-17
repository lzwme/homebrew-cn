cask "vieb" do
  arch arm: "arm64-"

  version "12.0.0"
  sha256 arm:   "6ee46f727676f4985088e38ee9397fc44506cbed6957640d18b95a37c0a201c3",
         intel: "2445bb822440585c9cdcc3866064ac860757f66e5bef9aa20df458e421effab5"

  url "https:github.comJelmerroViebreleasesdownload#{version}Vieb-#{version}-#{arch}mac.zip",
      verified: "github.comJelmerroVieb"
  name "Vieb"
  desc "Vim Inspired Electron Browser"
  homepage "https:vieb.dev"

  app "Vieb.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}vieb.wrapper.sh"
  binary shimscript, target: "vieb"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}Vieb.appContentsMacOSVieb' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportVieb",
    "~LibraryCachesVieb",
  ]
end