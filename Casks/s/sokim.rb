cask "sokim" do
  version "1.1.6"
  sha256 "125ffe88a167abc9f1267c7517810fc2ab8fc13212a1d3d1fa7a3479e6e06f8a"

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