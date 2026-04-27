cask "macskk" do
  version "2.12.2"
  sha256 "a2dfd588f1901fb7472997d7bee22bdd2a0b363be4052a176fb2a4ae55b1b7c0"

  url "https://ghfast.top/https://github.com/mtgto/macSKK/releases/download/#{version}/macSKK-#{version}.dmg"
  name "macSKK"
  desc "SKK Input Method"
  homepage "https://github.com/mtgto/macSKK"

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
    "~/Library/Application Scripts/net.mtgto.inputmethod.macSKK",
    "~/Library/Containers/net.mtgto.inputmethod.macSKK",
  ]
end