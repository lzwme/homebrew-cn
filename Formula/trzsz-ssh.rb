class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "9a7722470c49b1b233607aeab295d0fad3a24d457b98ff3ebd83bd8b005a73f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba447ef3a19a379ca7b3bb4db434f2e5e6c6d50fc494724dfda86becbae8c011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba447ef3a19a379ca7b3bb4db434f2e5e6c6d50fc494724dfda86becbae8c011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba447ef3a19a379ca7b3bb4db434f2e5e6c6d50fc494724dfda86becbae8c011"
    sha256 cellar: :any_skip_relocation, ventura:        "fdf63033e17186f0a5e57b9b5637435e15d3274d65c1af983e3aa23f57638505"
    sha256 cellar: :any_skip_relocation, monterey:       "fdf63033e17186f0a5e57b9b5637435e15d3274d65c1af983e3aa23f57638505"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdf63033e17186f0a5e57b9b5637435e15d3274d65c1af983e3aa23f57638505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93259fc82c7f782109b9dfe8a15f57d737a05a524b95921f46d1a9846937bde0"
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