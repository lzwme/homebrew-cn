class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "a3fe4ec7821a154bd181160b6b50e0062266e032c9111e3fea99d2ec67f0b80c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ac8004164588db01468259272023c4a6d93505008e9d8a92ca54737c306839b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ac8004164588db01468259272023c4a6d93505008e9d8a92ca54737c306839b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ac8004164588db01468259272023c4a6d93505008e9d8a92ca54737c306839b"
    sha256 cellar: :any_skip_relocation, ventura:        "b8c0220cebad5ede721f20e28af89bc1ab446cbf8240bc4c7c01d8a38a02277d"
    sha256 cellar: :any_skip_relocation, monterey:       "b8c0220cebad5ede721f20e28af89bc1ab446cbf8240bc4c7c01d8a38a02277d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8c0220cebad5ede721f20e28af89bc1ab446cbf8240bc4c7c01d8a38a02277d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4097b7d81784c297fe41ac0fe5a1df025b814ab2adf592247fde9edd10023976"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh -V")
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh --version")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc", 255)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz", 255)
    assert_match "invalid forward specification", shell_output("#{bin}/tssh -L 123", 255)
  end
end