class SwiftSection < Formula
  desc "CLI tool for parsing mach-o files to obtain Swift information"
  homepage "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection"
  url "https://ghfast.top/https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection/archive/refs/tags/0.14.0.tar.gz"
  sha256 "e993220dd03f88ec444acc0b4962383cbdd2597c8964a00f141ef0bb08f12e89"
  license "MIT"
  head "https://github.com/MxIris-Reverse-Engineering/MachOSwiftSection.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7f004488b49f353b38de3f1e3450916ca0e32427cede00898c4353ae0c576bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3887b37553b0cee2df0cbbc3cdd7a78a201f6701fe9bac244f3767f54c7e5da7"
  end

  # The Package.swift file requires Swift 5.10 or later.
  # But it is actually only builable with Swift 6.1+ due to the usage of trailing commma in comma-separated lists.
  depends_on xcode: ["16.3", :build]
  depends_on :macos

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "swift-section"
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