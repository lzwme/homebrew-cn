cask "azookey" do
  version "0.1.0-alpha.17"
  sha256 "00b91d81b63ea793e52ed22ec8f3fad47f8af8b3f950f2f2c03ad73201f5d5eb"

  url "https:github.comazooKeyazooKey-Desktopreleasesdownloadv#{version}azooKey-release-signed.pkg"
  name "azooKey"
  desc "Japanese input method"
  homepage "https:github.comazooKeyazooKey-Desktop"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+(?:[._-]alpha[._-]?\d+)?)$i)
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  pkg "azooKey-release-signed.pkg"

  uninstall quit:    "dev.ensan.inputmethod.azooKeyMac",
            pkgutil: "dev.ensan.inputmethod.azooKeyMac"

  zap trash: [
    "~LibraryApplication Scriptsdev.ensan.inputmethod.azooKeyMac",
    "~LibraryApplication Scriptsgroup.dev.ensan.inputmethod.azooKeyMac",
    "~LibraryContainersdev.ensan.inputmethod.azooKeyMac",
    "~LibraryGroup Containersgroup.dev.ensan.inputmethod.azooKeyMac",
  ]
end