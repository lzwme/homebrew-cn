cask "vieb" do
  arch arm: "arm64-"

  version "11.0.0"
  sha256 arm:   "225c0379f48ca566429162d112a376e390e3fa58907cb8cba7eb27fc0d61dacc",
         intel: "79db84942b2a6ab7fd61769911f25eb25da0e7099cfff5d1f808b426e239f316"

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