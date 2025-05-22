cask "sokim" do
  version "1.2.0"
  sha256 "d729ed4c10ab565125de9b6856374091561519e3b35e32a2ecbb1a86958ede78"

  url "https:github.comkidingSokIMreleasesdownloadv#{version}SokIM.pkg"
  name "SokIM"
  name "속 입력기"
  desc "Korean-English Input Method Editor"
  homepage "https:github.comkidingSokIM"

  depends_on macos: ">= :ventura"

  pkg "SokIM.pkg"

  uninstall pkgutil: "com.kiding.inputmethod.sok"

  zap trash: [
    "privatevardbreceiptscom.kiding.inputmethod.sok.*",
    "~LibraryApplication Scriptscom.kiding.inputmethod.sok",
    "~LibraryContainerscom.kiding.inputmethod.sok",
  ]

  caveats do
    logout
  end
end