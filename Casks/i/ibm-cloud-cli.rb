cask "ibm-cloud-cli" do
  arch arm: "_arm64"

  version "2.31.0"
  sha256 arm:   "f184ac6b6a6486ecfa4731471ea5daa6579942db585ed9d57ceaa82166c15f1b",
         intel: "be9528ca77bff26e15c2a9beaae8469f5fc508a92ad43bbd037366fe24218786"

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