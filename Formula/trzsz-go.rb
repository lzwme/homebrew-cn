class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "4f081fc3ff50fbb47348e5023d90c243280592a498c45659890f1496431e2854"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50ff6efb5131dd81507b421371e813a06299bff60b41a85fd61c6f96dddc6848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50ff6efb5131dd81507b421371e813a06299bff60b41a85fd61c6f96dddc6848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50ff6efb5131dd81507b421371e813a06299bff60b41a85fd61c6f96dddc6848"
    sha256 cellar: :any_skip_relocation, ventura:        "7f41c2dc996298240071021bdc3875329580143256f0bf362a3fc3ea95a18dda"
    sha256 cellar: :any_skip_relocation, monterey:       "7f41c2dc996298240071021bdc3875329580143256f0bf362a3fc3ea95a18dda"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f41c2dc996298240071021bdc3875329580143256f0bf362a3fc3ea95a18dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e309c19953ee4d93917a7f063acf12a924288bebe9abe8cc8d3d0fafcd4c69c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trz"), "./cmd/trz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tsz"), "./cmd/tsz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trzsz"), "./cmd/trzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}/trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}/trz --version")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}/tsz --version")

    assert_match "executable file not found", shell_output("#{bin}/trzsz cmd_not_exists 2>&1", 255)
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1", 255)
  end
end