class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "748727d6509143cae52f11f067d48bef8f89b495395c59b78e3e4740c69bc910"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28758ddd1dd2de39f5e9549f08914894bcc893cd00417e46d2a26d44ca84ad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28758ddd1dd2de39f5e9549f08914894bcc893cd00417e46d2a26d44ca84ad9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e28758ddd1dd2de39f5e9549f08914894bcc893cd00417e46d2a26d44ca84ad9"
    sha256 cellar: :any_skip_relocation, ventura:        "368dd8699297d58799570ccbd192a447ad45a9dcf4e0e2d1aad8e95dfff75b91"
    sha256 cellar: :any_skip_relocation, monterey:       "368dd8699297d58799570ccbd192a447ad45a9dcf4e0e2d1aad8e95dfff75b91"
    sha256 cellar: :any_skip_relocation, big_sur:        "368dd8699297d58799570ccbd192a447ad45a9dcf4e0e2d1aad8e95dfff75b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7ebb3e0992cb2bceee42f8550a1b5572a6641c0941aad9cdca2fffacba4f21"
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