cask "ibm-cloud-cli" do
  arch arm: "_arm64"

  version "2.25.0"
  sha256 arm:   "51e46a526babcf8d83d43d5d295721fa0aabe0b58f851f06fe06c95535a676b0",
         intel: "f7bc6ec083f61cbd66fe1a5aa1976d820e41ab06ad7314f5cd66aeef557d6957"

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