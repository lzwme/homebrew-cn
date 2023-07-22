class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "4acf9e7f10b49a7f6a9d56f441bcb3f1029a19207682db37b0cbd4adcc283d43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b39b8defce1cffa13bca3fd036117638413a3a7856b682b0b9e328b8a16ea1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b39b8defce1cffa13bca3fd036117638413a3a7856b682b0b9e328b8a16ea1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b39b8defce1cffa13bca3fd036117638413a3a7856b682b0b9e328b8a16ea1d"
    sha256 cellar: :any_skip_relocation, ventura:        "3806df97659cbc9c942657f4c5691205a8331ef2f65f0ac44b9e698aaeac6cec"
    sha256 cellar: :any_skip_relocation, monterey:       "3806df97659cbc9c942657f4c5691205a8331ef2f65f0ac44b9e698aaeac6cec"
    sha256 cellar: :any_skip_relocation, big_sur:        "3806df97659cbc9c942657f4c5691205a8331ef2f65f0ac44b9e698aaeac6cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "016dcb58be0ad50928b31ddc5f2e47da10e5545ad5e09711c83a231f3df77fb5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trz"), "./cmd/trz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tsz"), "./cmd/tsz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trzsz"), "./cmd/trzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}/trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}/trz --version 2>&1")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}/tsz --version 2>&1")

    assert_match "Wrapping command line to support trzsz", shell_output("#{bin}/trzsz 2>&1")
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1", 255)
  end
end