cask "vieb" do
  arch arm: "arm64-"

  version "12.3.0"
  sha256 arm:   "2340ff380609be0a856194fbe260e7e566f47437b7703f3030a24254cd878c7f",
         intel: "1a65188281e564217467446fc7fb9a5b86ac1803e7fba56c69434edaed5d127d"

  url "https:github.comJelmerroViebreleasesdownload#{version}Vieb-#{version}-#{arch}mac.zip",
      verified: "github.comJelmerroVieb"
  name "Vieb"
  desc "Vim Inspired Electron Browser"
  homepage "https:vieb.dev"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

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