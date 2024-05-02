cask "sf" do
  arch arm: "arm64", intel: "x64"

  version "2.39.6"
  sha256 :no_check

  url "https:developer.salesforce.commediasalesforce-clisfchannelsstablesf-#{arch}.pkg"
  name "Salesforce CLI"
  desc "Salesforce CLI tools"
  homepage "https:developer.salesforce.comtoolssalesforcecli"

  livecheck do
    url "https:raw.githubusercontent.comforcedotcomclimainreleasenotesREADME.md"
    regex((\d+(?:\.\d+)+)\s+\(.*?\)\s+\[stable\]i)
  end

  depends_on macos: ">= :el_capitan"

  pkg "sf-#{arch}.pkg"

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