class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.60.0.tar.gz"
  sha256 "01cb398cbda113d29a16eb4c0df5be38fee4f53ecb4215dfe582b7caa5635ee9"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "502c5b970e389388682f14b326e5837ada9ac90f6c8476d8060a1d505d378b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e407298d77e83adcd2dea67c030a75831c1887b85e336d6549aa0f0e099b9cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c806ef6e80e206277c2c490ced0c99e0a88bf32db6e58cbb6db76531882a6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f504b473e25f7dc2086d64a39543905ca213da8b6120e9b0f875a663c60a308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17de90d31b216eb00218450859d48e9916c8b1871ee235f182c001b97cfd8067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c914a037aa5f20a1a8015775fd0b004c3120c431e0ad81ce0241eda3847f6794"
  end

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
    system bin/"swiftformat", testpath/"potato.swift"
  end
end