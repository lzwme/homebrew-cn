class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.32.tar.gz"
  sha256 "4f7879cdc56c0e4702602cec026cc4825feae7bb5a28109dfef70830502e2d41"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ff49534b2c1b9e5705cec23548b5ee15b954d666bbd9ef919dee8645f712cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8341a3020e4c92ab5dddafb2a556238071fd3d05a24d98ef7be7a023da7cfa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52c206bcd7cc8e92107a4796f3b6721c863226072fedc09d01447b3ef8cf4fd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "29aba60281e4b742cf8ccc14ded91e9a1f59432b1170b851cdfd2ba8e97eca8c"
    sha256 cellar: :any_skip_relocation, ventura:       "37e91ea8cd6862aadd5e90b833d60ec5c7ca6caaa98469c300ae52bfb1efbb2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c871db5f5f1194381c02b6e27ecb30a98df9875489ea92bca26f483f8e5851ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end