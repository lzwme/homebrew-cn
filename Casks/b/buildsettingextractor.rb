cask "buildsettingextractor" do
  version "1.4.7"
  sha256 "2f200a5e88ae5520e246a32082924b80805203e5be2245b2ffaf6467a494857e"

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