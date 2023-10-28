class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-0.2.tar.xz"
  sha256 "aa53b22ad3bdce380c448f687b9c79872770d96308e3e797ca3fe6b11bbb0baf"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d62e8ad07d6e0d75a7ccdcb0e4de820e4a018f1502805a324c193ffdf907a825"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f75945f4fe2e2a26b20674ca779b209891823c7d9957d88cda1b89844b0d4dc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "091c2f011cae12433da6309b79a916b6f0b39ac3d0a952ce004a24eb5de92fbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "285853b9c2438e543c8244d50f67e31d33e985c0f1f8912a4828fc2fbb70bea5"
    sha256 cellar: :any_skip_relocation, ventura:        "7ead33b1f2dbbe3e77b3dbfb00d8098b268a259d33fc11d3c8ab92e364ccb652"
    sha256 cellar: :any_skip_relocation, monterey:       "f82c52f2ad9fc72c929854af054fccf8aefb1c1509801e10fba1dfdd3de57a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b941f5ae791f6700779fe3c3f38b2ced13e2556b3383fad78143c1055cc5c3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end