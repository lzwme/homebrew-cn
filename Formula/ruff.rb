class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  # ruff should only be updated every 5 releases on multiples of 5
  url "https://ghproxy.com/https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.250.tar.gz"
  sha256 "cb15e71efd68e2ec0b388f143dc2c46d9e25296e2c29e7af664060a635436385"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8c505cfa742e5cecb9b3de7809af9c14408c8bdb1eae3879adb1d5a3d318836"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f46373d13b96401ab3de22e9f3962119aadf7c7b0b6b9033f01628d6fc9692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7027885396d90a73bb0425619f42f5dd40c2462ccad92c1a646c3a5bfd2efdab"
    sha256 cellar: :any_skip_relocation, ventura:        "8850e460529bc57e637789b3506751535911660fd0f65649d7ae213695505261"
    sha256 cellar: :any_skip_relocation, monterey:       "ea629503615b68684c96438222892a5c7350bd6596e82477c989330b68637929"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7f54164a7f419899250e885c1734d5cb76944d997b999048f4cf84883247cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3fc7f33bdcc02f7c6a024186451c82550f573af2bb6671b66846cda8079dc8e"
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