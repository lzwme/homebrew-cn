class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.42.tar.gz"
  sha256 "0727500565f403c2261fc149cae49dcf00409f8ecd68b9ed1a1516a9437a6e91"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b59c74da7efa62a69d1458450f0b96f8821ebd6d5c4cc899cebeef30a918fcff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f0a91888df106ce39502145c721b0ef8a270251492ffb29170d533b37f6c018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2901acd43b42e5cb1a839a829406a43a49829835de47e9a6a3f94d233264f92a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1a3c480198099fb8a8ecf89a89c98c797ff3620dde339a7ebd2ffd0b6b230bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e278b77e00a7e3dbbc091d444f31cbe3364818e9c376504c0fe36a89359f0d59"
    sha256 cellar: :any,                 x86_64_linux:  "7a1fb00cb10e608a9abb7a8250f82fbb710bab5bbf02433a48d63b06ebc23193"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end