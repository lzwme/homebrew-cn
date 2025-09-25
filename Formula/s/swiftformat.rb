class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.58.1.tar.gz"
  sha256 "a136e20eb69ea25cdf855ef2025cbdfbd4a1b6195576142cc5a6af00e51f6225"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e470acdc870a850372876b8e2fe2e9dab9f582a2440c97f75e4267ffa1c2b5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffbacc755fc7bd198a7fc6f0d280335b34ff7d25ac0305a292c7d742bbfbd68c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e1282e7087cfcb81385dc64d498eace45b9a6880c1498009a4b7a3ff16f93e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "474abf7ac7dbd302aecc34e6c4d2fe72e1ab36833db0d4fbcedb4ef121b4434e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0e8a6c652430ca0fc48458b1b7f573e1c186af25220ca93f11793e505437206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec57635f0b7f4abfaca76871241d5c3237d9e64aaa4a73f8c6e0768afe6ec499"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", "#{testpath}/potato.swift"
  end
end