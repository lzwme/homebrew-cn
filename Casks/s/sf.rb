cask "sf" do
  arch arm: "arm64", intel: "x64"

  version "2.67.7,3acb081"
  sha256 arm:   "aa00cd2c4de533c20030c47f66cc1e5b072746fcb20a9583d020b5846473c4de",
         intel: "0a2292db6c2a4dbe6ee0b1c90fa8036778329ab166a167320c945d16e1b3a620"

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