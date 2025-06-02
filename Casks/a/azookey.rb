cask "azookey" do
  version "0.1.0-alpha.15"
  sha256 "1c7aa474320ab9ebef6232b63411acb293bec078b15192fb26a05a9112c5dddc"

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