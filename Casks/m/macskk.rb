cask "macskk" do
  version "2.1.1"
  sha256 "f9681067a27134439001d33c155c87293158a18ac4903aa64e515bfd8840d827"

  url "https:github.commtgtomacSKKreleasesdownload#{version}macSKK-#{version}.dmg"
  name "macSKK"
  desc "SKK Input Method"
  homepage "https:github.commtgtomacSKK"

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