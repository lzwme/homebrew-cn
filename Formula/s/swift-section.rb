class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https:github.comMxIris-Reverse-EngineeringMachOSwiftSection"
  url "https:github.comMxIris-Reverse-EngineeringMachOSwiftSectionarchiverefstags0.4.1.tar.gz"
  sha256 "afe48172e28e7ee626edf051d58662b62b63ddb6780e830cafbe886007af8029"
  license "MIT"
  head "https:github.comMxIris-Reverse-EngineeringMachOSwiftSection.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc22b3b35f2d1930d9499123a58f7a2d5d8db43789f9305bc9f4b9c428abcf5"
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