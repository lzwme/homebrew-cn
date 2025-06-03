cask "azookey" do
  version "0.1.0-alpha.16"
  sha256 "9cdb87112b2dd83e11342442930f38218e62442a8480e97d795ae785256456e9"

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