cask "macskk" do
  version "1.13.1"
  sha256 "00ae48bf44ecdcf03da90e5a65a4ac1deba188749c210e2a9fa6b6b4a8ea5d27"

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