cask "sf" do
  arch arm: "arm64", intel: "x64"

  version "2.59.6,767cea4"
  sha256 arm:   "c384f9bf3b92a1e57650b1b3b32ca5a31c8d8949aaf09a400b567ac6a489ff0b",
         intel: "e2c25aa70317e445a1cac6d70bcfc8d40f6afd6669e2a751f0c9e4a06d9816be"

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