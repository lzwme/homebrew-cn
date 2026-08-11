class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection"
  url "https://ghfast.top/https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection/archive/refs/tags/0.15.0.tar.gz"
  sha256 "100c73aab5df4448d72f76c211715aaaebaddcddd420599723f35d2b5eb5892e"
  license "MIT"
  head "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86599914f0703f4935208886dcfceba16bc6e7f594242abd7d29122120f10fde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c473067289ca368f98ede27726af98a22a8f43728d27d4af5f2d57a03b08acee"
  end

  # The Package.swift file requires Swift 5.10 or later.
  # But it is actually only builable with Swift 6.1+ due to the usage of trailing commma in comma-separated lists.
  depends_on xcode: ["16.3", :build]
  depends_on :macos

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--product", "swift-section", *std_swift_args
    bin.install ".build/release/swift-section"
    generate_completions_from_executable(bin/"swift-section", "--generate-completion-script")
  end

  test do
    (testpath/"test.swift").write <<~SWIFT
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
    system bin/"swift-section", "dump", "libTest.dylib", "-o", "output.txt", "-s", "types"
    assert_match "MyTestStruct", (testpath/"output.txt").read
  end
end