class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rzsz), and compatible with tmux"
  homepage "https:trzsz.github.io"
  url "https:github.comtrzsztrzsz-goarchiverefstagsv1.1.8.tar.gz"
  sha256 "9ff477c98081ffccecdd61b1bb51d573a0b67c7d205ecfc9d50b20dd4b54f3f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "534ff81d4dff7072e4786d57e64c69fa938e72f50757133d5553c7e29edbaf61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1116b86864ee5874affa1d2c0d099323187af43f213dfeb74aab41cadc10934"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1116b86864ee5874affa1d2c0d099323187af43f213dfeb74aab41cadc10934"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1116b86864ee5874affa1d2c0d099323187af43f213dfeb74aab41cadc10934"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd7d30223b48aadf61451c156036936de0a5492f0f0bf2598d316ec5f822d1dd"
    sha256 cellar: :any_skip_relocation, ventura:        "fd7d30223b48aadf61451c156036936de0a5492f0f0bf2598d316ec5f822d1dd"
    sha256 cellar: :any_skip_relocation, monterey:       "fd7d30223b48aadf61451c156036936de0a5492f0f0bf2598d316ec5f822d1dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867de3126f27ad11567dced2ecdac5c3f18f754345dae498c14dda8e0da8c1fa"
  end

  depends_on "go" => :build

  conflicts_with "trzsz", because: "both install `trz`, `tsz` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"trz"), ".cmdtrz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"tsz"), ".cmdtsz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"trzsz"), ".cmdtrzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}trz --version 2>&1")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}tsz --version 2>&1")

    assert_match "Wrapping command line to support trzsz", shell_output("#{bin}trzsz 2>&1")
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}tsz tmpfile 2>&1", 255)
  end
end