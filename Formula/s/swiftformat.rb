class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.59.0.tar.gz"
  sha256 "3547c8128d925dc92be59eb9c386a39533148b1ac91daaf1e6bbd5617eb0f75e"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49af7062a3c7c3e34b787174deaad4a7a2bb92330bbbdc9cdf94638458c43442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d94873a12daa46f22cb067f5bf593a0bb786fdf5460cf8c6dc386c7cfa9790ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de9ae74e3fd4634856d17356bc20a27b8ff611f190c4df68710dd8e703b2078f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1d18de1c6460ee0d0c3c9ef6c07caf3cf2dd490a5783cbd0fcf2ea056899438"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff1e46423fceb1b3fe05596bcd143b12f02662914cbc03c1460d59b3276a9d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5df13b6a60867c549fb68f93ea3b77924d55f0da46c547577ec78cfcf1a5ce8"
  end

  uses_from_macos "swift" => :build

  # Fix for macOS 13+ only Range.contains(_:) API, upstream pr ref, https://github.com/nicklockwood/SwiftFormat/pull/2328
  patch do
    url "https://github.com/nicklockwood/SwiftFormat/commit/9774a88b325382209eedc8e955cbaddc402b13a1.patch?full_index=1"
    sha256 "2f77becf3c71759e01ab1821871e6f78c10c25b7d3091b36f70202de3244eb26"
  end

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