cask "ibm-cloud-cli" do
  arch arm: "_arm64"

  version "2.32.0"
  sha256 arm:   "b5ec733db0c121af6fe064975c1c3b4002799249a7b2401509973bc2e17cd332",
         intel: "a79ce202b7a38488687c40248545a19a07786a9380b68a8adc56c6313a4f1e0a"

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