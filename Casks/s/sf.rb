cask "sf" do
  arch arm: "arm64", intel: "x64"

  version "2.77.6,b32a695"
  sha256 arm:   "0d76340ddd2b1b41c2b1ded7cbc857e748ba0680c2b2b45a7f0fce26f6b31e5e",
         intel: "5dd54ce98c76879f54ae77433dd4a2900ff58b9e417629eab8e9a2d03ca34df4"

  url "https:github.comsalesforcecliclireleasesdownload#{version.csv.first}sf-v#{version.csv.first}-#{version.csv.second}-#{arch}.pkg",
      verified: "github.comsalesforceclicli"
  name "Salesforce CLI"
  desc "Salesforce CLI tools"
  homepage "https:developer.salesforce.comtoolssalesforcecli"

  livecheck do
    url "https:developer.salesforce.commediasalesforce-clisfchannelsstablesf-darwin-#{arch}-buildmanifest"
    strategy :json do |json|
      next if json["version"].blank? || json["sha"].blank?

      "#{json["version"]},#{json["sha"]}"
    end
  end

  depends_on macos: ">= :el_capitan"

  pkg "sf-v#{version.csv.first}-#{version.csv.second}-#{arch}.pkg"

  uninstall pkgutil: "com.salesforce.cli",
            delete:  [
              "usrlocalbinsf",
              "usrlocalbinsfdx",
            ]

  zap trash: [
    "~.cachesf",
    "~.configsf",
    "~.localsharesf",
    "~.sf",
  ]
end