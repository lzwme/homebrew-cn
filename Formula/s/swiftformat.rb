class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.3.tar.gz"
  sha256 "5946e1e3d48a6053d079a44b6507c0049b481df9b744d85bc0e6459fcbd439f5"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec89f28834973d68c0ae63e61b071744d840ea2957e084d62c867e4fe4e0cec1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5883b9d596513f2b84ebed1a0f7ed0ee139e500b96e72aa484b821ed954cb280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7628393029242054d365109732ed46cef78387d250a275d7d1c791d03847da1d"
    sha256 cellar: :any,                 arm64_linux:       "9dfa89815adcfb979a685de76f8631e90387ebfae62f16221dc8bf7b625f392a"
    sha256 cellar: :any,                 x86_64_linux:      "b63edf17c9a048842196ad55af371bd3d7e72a95eee85bc6cad45e1a6990ee2a"
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