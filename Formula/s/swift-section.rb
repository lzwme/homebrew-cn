class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection"
  url "https://ghfast.top/https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection/archive/refs/tags/0.17.1.tar.gz"
  sha256 "fd4addf80a40831e11e9f4aa2661c7677b2fe296f4ace42988ba9c7c0dbc6830"
  license "MIT"
  head "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c5d3e480c41704b8c77f0eeb236d36a9b9a96b28771748ce903eaabf843198b2"
  end

  # The Package.swift file requires Swift 6.2 or later.
  # But it is failed to build on Sequoia with Xcode 26.3
  depends_on xcode: ["26.4", :build]
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