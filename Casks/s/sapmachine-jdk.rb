cask "sapmachine-jdk" do
  arch arm: "aarch64", intel: "x64"

  version "22.0.1"
  sha256 arm:   "79fef7b42f3b9e30752930684cc3691e5959bc1ed194978894f89d6364066522",
         intel: "f73313885216e9a0612524a0b5294632887b5b5cfb1121a5c315e78a0bcc8832"

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