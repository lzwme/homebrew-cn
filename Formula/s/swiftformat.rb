class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.2.tar.gz"
  sha256 "91661492efd6b2a6037654e2955970c8441a7e1e68f7f893894d3197761d9a41"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f3294a3865b6af8ec638b25fef79b1268a090350ed1f4e70ac4c404047ea41b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2dabe777b804660a0efb57dae357e43feeb584049fdf7b74e30af35a4261e486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d9e0909d0e2105c92d0b0b3c053c0b37fc8d07d2f07a1514717e6c014477c68"
    sha256 cellar: :any,                 arm64_linux:       "2275d6a4713c5e555201e77d344a969b41f87e3fe8689f3797923dd9b8e38d92"
    sha256 cellar: :any,                 x86_64_linux:      "f823a54ac863b0530dbe284221632dd6ac16e5001e59908233eff6cc2bffd0b5"
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