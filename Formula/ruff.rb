class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://ghproxy.com/https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.263.tar.gz"
  sha256 "fae17e891dca8d65c0d91172857c1dab63944a1cccf0959c6e81c8d228a4ee39"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c09987bc2f11a7471964602061115d720f2bf7defbe8899127ada421739f55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64cfadf749dee0eb7cdcb3ba2c0dd831c608f80a558298aa6659e5ab48673a97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcf2bd74970df31b40d64dbc24f246c5507a7f109197b72d589ac662e279f7a4"
    sha256 cellar: :any_skip_relocation, ventura:        "734d4dbb7aeefee6910a5027d68e6ee7d4e07bf69818ae78a47e13bf53804b0b"
    sha256 cellar: :any_skip_relocation, monterey:       "138ee4b9a9b52694dc7556ee5c6d85fa400091ecb3184f48d244dc5fc2f8eb7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "86f007ef2e0f4598a2342a0dad7f389118fc9ae42ffcb1ce48059a8b5940ef6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8145e7f044dc871c2dc438a7f0db501d3badd4ff4d49d0bf5c79702d905179a3"
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