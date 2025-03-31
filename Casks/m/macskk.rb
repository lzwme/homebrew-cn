cask "macskk" do
  version "1.12.1"
  sha256 "d287780c4c78206fe7311b4d0115e7afc00a3eadadee11f808ac0666e6fa91b4"

  url "https:github.commtgtomacSKKreleasesdownload#{version}macSKK-#{version}.dmg"
  name "macSKK"
  desc "SKK Input Method"
  homepage "https:github.commtgtomacSKK"

  auto_updates true
  depends_on macos: ">= :ventura"

  pkg "macSKK-#{version}.pkg"

  uninstall quit:    [
              "net.mtgto.inputmethod.macSKK",
              "net.mtgto.inputmethod.macSKK.FetchUpdateService",
              "net.mtgto.inputmethod.macSKK.SKKServClient",
            ],
            pkgutil: [
              "net.mtgto.inputmethod.macSKK.app",
              "net.mtgto.inputmethod.macSKK.dict",
            ]

  zap trash: [
    "~LibraryApplication Scriptsnet.mtgto.inputmethod.macSKK",
    "~LibraryContainersnet.mtgto.inputmethod.macSKK",
  ]
end