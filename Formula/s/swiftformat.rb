class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.62.0.tar.gz"
  sha256 "7ccbb3a4e31592b34c5bcc04575af3af98da7863a234e2f8f5315295e14d30dd"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8d39f5af0ef7862e7635168def6b068903dca83357de18484774247ec9b4970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0598a8901ed0cd4189304a5bec7ac52888fc2325136741e9626aa25b6ba6f86a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a49ec498e12539f90d989351ab533caba9a84ed6c4104d77ca9d1c8befb51651"
    sha256 cellar: :any_skip_relocation, sonoma:        "41746c0a91d8e9d3b02c3bc40d1543c67b7a9f160d5269fb2f4467da2c63a0ca"
    sha256 cellar: :any,                 arm64_linux:   "91d2408c858b0438047b66e45366c1ed58dd6e31bde894854bbb8d990d4ebf92"
    sha256 cellar: :any,                 x86_64_linux:  "9837cb39a290cab7a06be3e57c8bb4d77219cdea98cbfd6514414a0db53d25f5"
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