cask "ibm-cloud-cli" do
  arch arm: "_arm64"

  version "2.32.2"
  sha256 arm:   "207f9485f220e4dc907a7c80a4c9140bce985722b26148cf08a542aa863f6798",
         intel: "7e806e07b8571a44090daac41eaa7e25f7894cbac55929f03ccee3b0c1f73fe2"

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