cask "sf" do
  arch arm: "arm64", intel: "x64"

  version "2.90.4,1709262"
  sha256 arm:   "6fb8833b79cdea17c6ed96528bdb47f2e0d36833c5e03d0057f1846abf8092a5",
         intel: "89b5b590984c5e6a1b2aee43f5a03c43cd716adbb01681145328b1ff2e022f1b"

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