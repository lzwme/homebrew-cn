cask "ibm-cloud-cli" do
  arch arm: "_arm64"

  version "2.24.0"
  sha256 arm:   "4ff097ef16a823abaefe6f135b563a917614491089929825f99e928c384f2e8c",
         intel: "4cc285ce2c333fafffd4866492c23e25fbf7f663c71bf17a4293983597fbfd6d"

  url "https:download.clis.cloud.ibm.comibm-cloud-cli#{version}IBM_Cloud_CLI_#{version}#{arch}.pkg"
  name "IBM Cloud CLI"
  desc "Command-line API client"
  homepage "https:cloud.ibm.comdocscliindex.html"

  # Upstream publishes file links in the description of GitHub releases.
  livecheck do
    url "https:github.comIBM-Cloudibm-cloud-cli-release"
    regex(IBM[._-]Cloud[._-]CLI[._-]v?(\d+(?:\.\d+)+)#{arch}\.(?:dmg|pkg)i)
    strategy :github_latest do |json, regex|
      match = json["body"]&.match(regex)
      next if match.blank?

      match[1]
    end
  end

  pkg "IBM_Cloud_CLI_#{version}#{arch}.pkg"

  uninstall pkgutil: "com.ibm.cloud.cli",
            delete:  [
              "usrlocalbinbluemix",
              "usrlocalbinbx",
              "usrlocalibmcloud",
            ]

  zap trash: "~.bluemix"

  caveats do
    files_in_usr_local
  end
end