cask "sapmachine-jdk" do
  arch arm: "aarch64", intel: "x64"

  version "21.0.2"
  sha256 arm:   "5382dbb1f80b2c5bdac2713cf6e3a9aec2b7315b62870f110ac7dae628c8f08e",
         intel: "06f1e707b913e6ca3f3ac7714bda28ebebb0d2cc8f9a3a7cb89f17281da4c2f0"

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