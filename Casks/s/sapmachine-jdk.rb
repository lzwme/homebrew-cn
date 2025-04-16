cask "sapmachine-jdk" do
  arch arm: "aarch64", intel: "x64"

  version "24.0.1"
  sha256 arm:   "54369f1ec902aa276c2461844783288ed538ab13869bcf02f113e0577cb22515",
         intel: "e34ea8916cecff0dfc034e8bae73107e76c3c32a1ef770bf9eaec0d9a7ee5a7b"

  url "https:github.comSAPSapMachinereleasesdownloadsapmachine-#{version}sapmachine-jdk-#{version}_macos-#{arch}_bin.dmg",
      verified: "github.comSAPSapMachine"
  name "SapMachine OpenJDK Development Kit"
  desc "OpenJDK distribution from SAP"
  homepage "https:sapmachine.io"

  # The version information on the homepage is rendered client-side from the
  # following JSON file, so we have to check it instead.
  livecheck do
    url "https:sap.github.ioSapMachineassetsdatasapmachine-releases-latest.json"
    regex(^sapmachine[._-]v?(\d+(?:\.\d+)*)$i)
    strategy :json do |json, regex|
      json.map do |_, item|
        next if item["ea"]

        item["releases"]&.map do |release|
          match = release["tag"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  artifact "sapmachine-jdk-#{version}.jdk", target: "LibraryJavaJavaVirtualMachinessapmachine-jdk.jdk"

  zap trash: "~LibrarySaved Application Statecom.sap.openjdk.jconsole.savedState"
end