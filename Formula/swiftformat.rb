class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.51.4.tar.gz"
  sha256 "49e2cdd5b80c0484c5e124e3f7abde7b02076ba2a87c56972dc5438e6c4e25c0"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1e0a2c0728d2df9538fad2a7dd40b1155eaa806a7c4e55859ea73d989496b56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cb0448cb2cf0a9d2197877496a9ca41a5d80345b3d96987f1dcfd2c2dfb3ef9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21b5bd7677938ac5297dfcca5860881059af92ad1489d83d6124b18abf7e1346"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ee389cc14684f33018ff8c78b581f0d3bc4b46f9101a7c863c1bbc967c4eea"
    sha256 cellar: :any_skip_relocation, monterey:       "b2a3eaa54aaaabf53ea77902f6946770e9e1a1b54f44b0cd9133e82fda99030b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2794241291b74f6e65e9ea60feb6b1bc86091f68d1ba1b66bc0f44ebc44fc038"
    sha256                               x86_64_linux:   "8c56a1a33e1d7952c70edbf5c3fec1ea67f5bc90b3bd76e3b46156299232162e"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end