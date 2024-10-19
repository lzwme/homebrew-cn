cask "sapmachine-jdk" do
  arch arm: "aarch64", intel: "x64"

  version "23.0.1"
  sha256 arm:   "2901ff85a1bf7a317a785acbd246a77d4cef1d0fb9c6914119319cf251d200bb",
         intel: "00c523153e3e9c115c6f2205b771a8d7da17132d92a3cf29b414cf5f16844077"

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