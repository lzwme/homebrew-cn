class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.4.tar.gz"
  sha256 "53a09e3b0f904c2716d789dcfec0991e239927a623634a3c7745750fe39f9e04"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f51d263bd052d07b8119a2caad3d1eff87f20dfd45c4fdc5d275235350699f8f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e111d74e33c2c2dda369fc1ca0674946a2968916a130aa76b7fec50e183934f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dad5fa560b212f5091fe14799c4625a5c4932671f1cc491a4fff941e2c8860fc"
    sha256 cellar: :any,                 arm64_linux:       "8564c08fc1844acc14cdb89af45c4c57f2465fe454925b65761aef42652c0d94"
    sha256 cellar: :any,                 x86_64_linux:      "0011da085019b43c29059d81793d98d86ba9beaddd57d839a3e5fa6b54133872"
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