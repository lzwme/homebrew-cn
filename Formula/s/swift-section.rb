class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https:github.comMxIris-Reverse-EngineeringMachOSwiftSection"
  url "https:github.comMxIris-Reverse-EngineeringMachOSwiftSectionarchiverefstags0.5.0.tar.gz"
  sha256 "34de34e7319dbb084236fe48f9e2eee5e4c2698fa261165612721efd10f1cbc0"
  license "MIT"
  head "https:github.comMxIris-Reverse-EngineeringMachOSwiftSection.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "719b59f62cf442d4a49a9917edd1318009c38f2718b1ae951d9454f964aacbcd"
  end

  # The Package.swift file requires Swift 5.10 or later.
  # But it is actually only builable with Swift 6.1+ due to the usage of trailing commma in comma-separated lists.
  depends_on xcode: ["16.3", :build]
  depends_on :macos

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".buildreleaseswift-section"
  end

  test do
    (testpath"test.swift").write <<~SWIFT
      public struct MyTestStruct {
          public let id: Int
          public let name: String
          public init(id: Int, name: String) {
              self.id = id
              self.name = name
          }
      }
    SWIFT

    system "swiftc", "-emit-library", "-module-name", "Test", "Test.swift", "-o", "libTest.dylib"
    system bin"swift-section", "dump", "libTest.dylib", "-o", "output.txt", "-s", "types"
    assert_match "MyTestStruct", (testpath"output.txt").read
  end
end