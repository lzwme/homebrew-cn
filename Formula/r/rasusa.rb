class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://ghfast.top/https://github.com/mbhall88/rasusa/archive/refs/tags/5.0.1.tar.gz"
  sha256 "9d7841eafd9267a779b9966504879051ebdb56c7b11e68f1a5f550bc0064cd2c"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cada0897b4e5f3699020ee64b59e67b5396e911491973d97b74ed81c1e892400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aa259d0decd2338c78d7d8230d1b470c423a4444643412a057bade980ac8378"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "240de793b33f6fbc772a1119e7e44b064fc7c259a7a43288f2ecb5b042ede799"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b38371044492bc93a1fa1be6339ecaad3e7dc293ae655e6f25cccd64d0a0609"
    sha256 cellar: :any,                 arm64_linux:   "28927596abcb72b4d8801085f289643a119685fe44b60bb9eabf1fd1865c65cb"
    sha256 cellar: :any,                 x86_64_linux:  "05a23600307e8ce85557a1ff0cdc3ecff961898fc300d41132258372256e7c74"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/cases"
  end

  test do
    cp_r pkgshare/"cases/.", testpath
    system bin/"rasusa", "reads", "-n", "5m", "-o", "out.fq", "file1.fq.gz"
    assert_path_exists "out.fq"
  end
end