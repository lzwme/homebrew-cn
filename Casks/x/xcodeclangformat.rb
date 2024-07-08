cask "xcodeclangformat" do
  version "1.2.1"
  sha256 "efc9e926db308977d9ad1ce39925b5c3270eb05aec97a4ae988250d31619d97c"

  url "https:github.commapboxXcodeClangFormatreleasesdownloadv#{version}XcodeClangFormat.zip"
  name "XcodeClangFormat"
  desc "Format code in Xcode with clang-format"
  homepage "https:github.commapboxXcodeClangFormat"

  app "XcodeClangFormat.app"

  zap trash: [
    "~LibraryApplication Scriptscom.mapbox.XcodeClangFormat",
    "~LibraryApplication Scriptscom.mapbox.XcodeClangFormat.clang-format",
    "~LibraryContainerscom.mapbox.XcodeClangFormat",
    "~LibraryContainerscom.mapbox.XcodeClangFormat.clang-format",
    "~LibraryGroup ContainersXcodeClangFormat",
  ]

  caveats do
    requires_rosetta
  end
end