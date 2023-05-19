class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://ghproxy.com/https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.269.tar.gz"
  sha256 "6f9e10fa0aa0495d2da8cf9113beaa12ba6020749b0fbc98a92713c65f2d2a14"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ce4f2808a9db895d5220035544a5529f862ed7dd4a6824042beae9d1c6fb31c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec90dc2d384edd58674488946e69506f0d463fa3e61908efd47b848b6f4fa962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07e994105d5cce3f5895fd6c4d39da833fbff6af94c4b5ded67439bc0c7d0770"
    sha256 cellar: :any_skip_relocation, ventura:        "a77c110e318b0f4ce0b097221edc7042e7a84e935206527a462fd63f72fd438b"
    sha256 cellar: :any_skip_relocation, monterey:       "d3810fe36ab645b9ca34702a37053d4094ab355f93662a4641dcf74ca5fad99e"
    sha256 cellar: :any_skip_relocation, big_sur:        "13959a144ba0b61eda5fc54f14fc3e0285b11ba3fadddaf7a80719d0e57b1de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fcf2da09dbcd8fcd00f4b6cc2bfcf8d761bc05553a18376bbcb0499decc1588"
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