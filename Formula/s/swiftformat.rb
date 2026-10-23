class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.1.tar.gz"
  sha256 "d2c3793bcc8edcf4e25f321617d3bc52132d20ec4ee7692cf73f94d3bedfc0b3"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69cec23dd75a483cb33fb4de0fa3f48f76ae8a38bd224f428d05063397ed9786"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ef1235dd14aaaeba4f877a79f641231222e16bf5d8eb2f9485edc7c09b26836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef37b6b9288b761169d05bb7d44d4c5e95ab536bc992a01062058828e1341629"
    sha256 cellar: :any,                 arm64_linux:       "743bb31d20aabb38526a150d22b3406932bc557b0b133b347c996d44ae84e9f9"
    sha256 cellar: :any,                 x86_64_linux:      "1d168da011a8cc26774f5d7b71ab74e42609ba18059b0357890ba6b57a060ff8"
  end

  uses_from_macos "swift" => :build

  deny_network_access!

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", testpath/"potato.swift"
  end
end