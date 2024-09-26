cask "spyder" do
  arch arm: "arm64", intel: "x86_64"

  version "6.0.1"
  sha256 arm:   "ba997b0bbefd6f025a88046f44139b311249842296290d5fb41a36a346f702bb",
         intel: "72c3c71b29d9daa9ed2323faf0e5f56b1cc71bae02273153ca4410171fc639a7"

  url "https:github.comspyder-idespyderreleasesdownloadv#{version}Spyder-macOS-#{arch}.pkg",
      verified: "github.comspyder-idespyder"
  name "Spyder"
  desc "Scientific Python IDE"
  homepage "https:www.spyder-ide.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  pkg "Spyder-macOS-#{arch}.pkg"

  uninstall quit:    "org.spyder-ide.Spyder",
            pkgutil: "org.spyder-ide.Spyder.pkg*",
            delete:  "ApplicationsSpyder #{version.major}.app"

  zap trash: [
    "~.spyder-py3",
    "~LibraryApplication SupportSpyder",
    "~LibraryCachesSpyder",
    "~LibrarySaved Application Stateorg.spyder-ide.Spyder.savedState",
  ]
end