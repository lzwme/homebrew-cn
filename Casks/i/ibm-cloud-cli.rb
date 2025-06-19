cask "ibm-cloud-cli" do
  arch arm: "_arm64"

  version "2.34.2"
  sha256 arm:   "0140666421cf522c4633c187cdcdfee0af9753910f5b39e422c58e298bc388ab",
         intel: "9dca15184e0a06cd2f27c3f37d565719a78923a181582a52e6beb59498e5cd84"

  url "https:download.clis.cloud.ibm.comibm-cloud-cli#{version}IBM_Cloud_CLI_#{version}#{arch}.pkg"
  name "IBM Cloud CLI"
  desc "Command-line API client"
  homepage "https:cloud.ibm.comdocscliindex.html"

  livecheck do
    url "https:github.comIBM-Cloudibm-cloud-cli-release"
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