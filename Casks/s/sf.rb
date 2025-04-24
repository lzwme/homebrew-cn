cask "sf" do
  arch arm: "arm64", intel: "x64"

  version "2.85.7,d15631c"
  sha256 arm:   "22e9b39eb0643dbedd8aa0e34f67255f68cfe780a2206a337a80f061bfc15b59",
         intel: "04d678fd85847de20619842ce9a825b022066c4a22be8f5f2920caf88dbd4c98"

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