cask "vieb" do
  arch arm: "arm64-"

  version "12.1.0"
  sha256 arm:   "5018df5c7c360da4b2c487f8fae0cf7d35f7e3955edbdd2c2f2abd51b7268908",
         intel: "6201e6e596b1a56db97700133786d8b068c7c134cf79dd44035d71cd0ef42cad"

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