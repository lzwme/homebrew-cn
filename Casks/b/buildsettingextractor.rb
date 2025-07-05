cask "buildsettingextractor" do
  version "1.4.8"
  sha256 "ae7d0c66c830a18d3f6483b102dc2c8eec302e05d3454dc2d526a01b95a91cd0"

  url "https://ghfast.top/https://github.com/dempseyatgithub/BuildSettingExtractor/releases/download/v#{version}/BuildSettingExtractor_#{version}.dmg"
  name "BuildSettingExtractor"
  desc "Xcode build settings extractor"
  homepage "https://github.com/dempseyatgithub/BuildSettingExtractor"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "BuildSettingExtractor.app"

  zap trash: [
    "~/Library/Application Scripts/net.tapas-software.BuildSettingExtractor",
    "~/Library/Containers/net.tapas-software.BuildSettingExtractor",
  ]
end