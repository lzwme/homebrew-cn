cask "buildsettingextractor" do
  version "1.4.6"
  sha256 "a8828f75838bf026c75f6847be458a2488e4c6ccaf3158321c5084eba733d341"

  url "https:github.comdempseyatgithubBuildSettingExtractorreleasesdownloadv#{version}BuildSettingExtractor_#{version}.dmg"
  name "BuildSettingExtractor"
  desc "Xcode build settings extractor"
  homepage "https:github.comdempseyatgithubBuildSettingExtractor"

  depends_on macos: ">= :mojave"

  app "BuildSettingExtractor.app"

  zap trash: [
    "~LibraryApplication Scriptsnet.tapas-software.BuildSettingExtractor",
    "~LibraryContainersnet.tapas-software.BuildSettingExtractor",
  ]
end