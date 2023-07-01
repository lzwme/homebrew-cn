class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://ghproxy.com/https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.6.2.tar.gz"
  sha256 "fd1e7566387f7104c3c83a7818e160eda399c6efedcd3d262088a28a35eb01e1"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c26f49f3b74c8609b3f4b07650b9dcb6667ba2cd220dc3e20c6f1b6ee558a763"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a7a8ba2f44e3aeebf82ce9d5e0f9a5dee1a60107ecee4dc322425c4ef6fcc1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e17a3528b0607ea518cddeb42fdae5a3415d0b8ab7012f9f0f7db6bb40e7ba24"
    sha256 cellar: :any_skip_relocation, ventura:        "6fe661609b7048d878c84d8cf0f2aa585acbdfdbd9e44396471df9e85f571bd4"
    sha256 cellar: :any_skip_relocation, monterey:       "1f5db7989ad1ada9b1bb559c4166a85f1216085a65c2974a1cb853efcb0c4096"
    sha256 cellar: :any_skip_relocation, big_sur:        "99e3bd162e3593efd95be27443dd1505e3d5cf1ccbc22bcb994e4de261299c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5703c931b6e8f9380f194423dfddc8dad506c0befd404b6d909dfeeceed24f"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_predicate testpath/"osshim", :exist?
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end