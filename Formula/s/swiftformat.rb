class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.63.1.tar.gz"
  sha256 "2a783642fcaa2c42bf8d9584820e1e02fd16b3e0cec02fe9629d918403aefb2b"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c22f0bb272e1b3b96d7d506be5c381d085af800c2d06cc2267c5c3965c53792"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9b7e16aa9bcd68e3b1cf6e922b77b0ac821a436c6348e310b06e4f807e0781b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f266fe961b1648bd923e672f3b50f9ebd8c1e5ac6508e64aa8c386e37d30a7ae"
    sha256 cellar: :any,                 arm64_linux:       "f44c2ad148c519b5916f98d5a19dce589658f91547c4f311b69fc1b58a1f9c9f"
    sha256 cellar: :any,                 x86_64_linux:      "ce7301e672437ee88a4f0a72a57ca98e461b6b4ffead4eea7d782314a0a18fba"
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