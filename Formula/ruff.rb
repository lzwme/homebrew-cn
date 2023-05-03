class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://ghproxy.com/https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.264.tar.gz"
  sha256 "c5ae75b74965d32a00cb30555315e2cd257f9c055e2fdb280ebf768263695d3d"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78eabc1c13d09e00da332be85cc11ca99807e0019cac64e0217b372887f89618"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9042dab832905c938baebf90afb2ad01e0dd294af3e3eac355e2ca49fbdd8a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9ed5bdbbc71a5330ae6df97f3fca067775ef0e7db4ae14d1b64edac40b84fbc"
    sha256 cellar: :any_skip_relocation, ventura:        "fc562df82e3c5c470f02ea5691c80673210318bbc62e476f683f1f5bb2fc583d"
    sha256 cellar: :any_skip_relocation, monterey:       "94ea2c006e67cfee833179c0337035609c81e3a7b4f6227480de7429532e7f1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0f2cfdf44eb5e018223e73131d7bf9aab663b8da281ea41a9471130fbbbcbd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10368332dbc3a49ea807fc5f6f92608b12fdd7195e757a97393ba16ad5256e0d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end