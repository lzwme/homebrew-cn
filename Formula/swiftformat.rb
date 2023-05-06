class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.51.9.tar.gz"
  sha256 "d8fc42616479360db48911ab57b8849656c7a103ab76e527176b6e8e0e0fc515"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbb01c5c7fcde4f8b17945c2c8386b099848c9cd4fda8bcfd032c2420d5d1b65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f04596d4567e86f46e0740ea3e9d1e2e19fa1cdf137a70287342b6ce937ddf8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8b6f0f30662dd4c2e1eb64d614fe2765ad664e2ac10a346004f94ed6ed6cdf2"
    sha256 cellar: :any_skip_relocation, ventura:        "dc2be8c829dc26595577f8b5daa071324f341c4f144cc46bf0a47520d44fc76e"
    sha256 cellar: :any_skip_relocation, monterey:       "a88b992a2316fa06dd13944c6bb16d00522de0cc21aae17ede07e65d700c6800"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba2cf56b5845bb33265a3e32737c5defa6e310987f785e1dfe6e7dc114a12555"
    sha256                               x86_64_linux:   "d1f82ed96ee9f8f239e9396bff00a0feac937fe12840d05fb6d5c01fe9161f03"
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