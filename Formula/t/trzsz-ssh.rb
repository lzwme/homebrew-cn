class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "15b7c40adf09b53f3d3d8f7f592390908b56a4fdd7318dd5f8dfc6e288ca61c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ca49b45375b70ad7ddab7ce8876f28dcc35d2bc29a5b2fc91f6127409d35fc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02e050242327c7f46796320da05f383155076f015093624ac5c36770826374a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "877051ec62b7fef67111929904268e9e986e18b7d844c83ba95084c4147d5e31"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f5f6a344704275628a4558bb2a48667774d7d0d6cbad43186b699e4214954c0"
    sha256 cellar: :any_skip_relocation, ventura:        "f60e891509c1f3afc93bfa205aff0a8461c56869ba9ec3fae90d7b1dd9e98d00"
    sha256 cellar: :any_skip_relocation, monterey:       "21de5a438c064a0bc3306d8ad1ee5dd62ace66032fd88bdfa16de9a6e6f557fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46f4caf4b0d904fdd5db1a2eb7de9e072eeb6c1dd96bf83e68b97a32fc50579a"
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