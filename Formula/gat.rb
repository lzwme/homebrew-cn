class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://ghproxy.com/https://github.com/koki-develop/gat/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "d2002f2ce653213dcbb2db6f4fa0a95f83ef520aee7ff78ccf83c5f7c7aa1859"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "839a78225f733108a82d6d347bf5ded39c916978dc781d5f791f252f040a1312"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "839a78225f733108a82d6d347bf5ded39c916978dc781d5f791f252f040a1312"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "839a78225f733108a82d6d347bf5ded39c916978dc781d5f791f252f040a1312"
    sha256 cellar: :any_skip_relocation, ventura:        "d0e1445cdc6e8839ec43273f146fb82a97cc450d60af49a815ed9822bcadadf9"
    sha256 cellar: :any_skip_relocation, monterey:       "d0e1445cdc6e8839ec43273f146fb82a97cc450d60af49a815ed9822bcadadf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0e1445cdc6e8839ec43273f146fb82a97cc450d60af49a815ed9822bcadadf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e81ea62985bcebe7add09d652fb218f0d3dae64dccf706d1ae0a46d9ad4990bc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end