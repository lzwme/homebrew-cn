class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection"
  url "https://ghfast.top/https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection/archive/refs/tags/0.20.0.tar.gz"
  sha256 "8dc620fa3e74ae068ff0010b30796e50b69c6ee97ff8593453b620c40510af15"
  license "MIT"
  head "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7092c4af0152d4ae90a5fc35363d2bc307de902d44703694d46056c53bca29fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3947ecc149155c8775af6572ebbbd2f22390aca2edd2611ff42ae2068233f585"
  end

  # The Package.swift file requires Swift 6.2 or later.
  # But it is failed to build on Sequoia with Xcode 26.3
  depends_on xcode: ["26.4", :build]
  depends_on macos: :tahoe # aligned to build Xcode as cannot cross-compile

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