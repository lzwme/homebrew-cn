class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghfast.top/https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.58.5.tar.gz"
  sha256 "f4220005165422a7f9134bd1ef4bb623e66c862bf4524463a9d0562b26b6f1ff"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e407dd49cc6e090d9f52c81e308195d4b1990297f63d89c9260d919c61a9654"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c25acd66fc04fd7caa8704fc29d563787b56c1e58528bd55a97048302736a66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac5bb4d39e420c8744ea790953203dd3c8cb31c9c10c4dc155a3a4875080a826"
    sha256 cellar: :any_skip_relocation, sonoma:        "df9974a25e34a892f29d502da150fd68d1e4f223deb2fcefa5b68e9de740aa87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0501630545a77ad2f57e9908dae6ee6150b5937618975598f073d2d3f207717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92df6c5d376242f6bb570f3a45387104a811ab8ae38eb6c403d80ad4416dae2e"
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