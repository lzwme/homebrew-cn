cask "sapmachine-jdk" do
  arch arm: "aarch64", intel: "x64"

  version "23"
  sha256 arm:   "5776c2f9af88c17dfeaffb706ae8d8747e945009a3c3df50021800dd57d271b8",
         intel: "130eff5d69d631be94b0f81829f9fee0e8f592e37c5d62878a147486c2a4bf39"

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