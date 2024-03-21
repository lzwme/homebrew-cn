cask "sapmachine-jdk" do
  arch arm: "aarch64", intel: "x64"

  version "22"
  sha256 arm:   "b275798b5028071d7637fc70b5cbe28ed55f03259793983322ea3d8e8c1f6540",
         intel: "528419c3ae4dc7fa04054eeeaae912407566190016ba56457dfcaa823ac4262f"

  url "https:github.comSAPSapMachinereleasesdownloadsapmachine-#{version}sapmachine-jdk-#{version}_macos-#{arch}_bin.dmg",
      verified: "github.comSAPSapMachine"
  name "SapMachine OpenJDK Development Kit"
  desc "OpenJDK distribution from SAP"
  homepage "https:sapmachine.io"

  # The version information on the homepage is rendered client-side from the
  # following JSON file, so we have to check it instead.
  livecheck do
    url "https:sap.github.ioSapMachineassetsdatasapmachine-releases-latest.json"
    regex(["']tag["']:\s*["']sapmachine[._-]v?(\d+(?:\.\d+)*)["']i)
  end

  artifact "sapmachine-jdk-#{version}.jdk", target: "LibraryJavaJavaVirtualMachinessapmachine-jdk.jdk"

  zap trash: "~LibrarySaved Application Statecom.sap.openjdk.jconsole.savedState"
end