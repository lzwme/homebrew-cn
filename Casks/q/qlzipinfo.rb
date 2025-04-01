cask "qlzipinfo" do
  version "1.2.7"
  sha256 "397aef8f48bb62865ee6f8655b3e622e2b90eab2c67acbf775a95a23f63a0c25"

  url "https:github.comsrirangavqlZipInforeleasesdownloadv.#{version}qlZipInfo-#{version}.dmg"
  name "qlZipInfo"
  desc "List out the contents of a zip file in the QuickLook preview"
  homepage "https:github.comsrirangavqlZipInfo"

  depends_on macos: ">= :high_sierra"

  qlplugin "qlZipInfo.qlgenerator"

  # No zap stanza required
end