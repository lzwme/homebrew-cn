class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.9.1.tar.gz"
  sha256 "661c71f5884476eda3af5143141ab71eec948514c4918cc2cfa75f2ece404d4e"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e563bdf1aaf17c48b0c5514e2f29f27468ed06fe78fb6b89bd48a00f7a23e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27fbaca9defb76f6368c237182736cc4f3a6559d660bdf149ae8c179dfeedd44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52cc501f285a6aa16e1d909a52bd87c238d9b7b71baa85f1c62a9e24a2d782c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c972c87b7683accfba2d6ca13630c8f5f8b51b65d4ab53e4f550763187c01f52"
    sha256 cellar: :any_skip_relocation, ventura:       "9b66e32e35076ab6545ae3938f0497c513c9c5610ab35afbde74480600b0e903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0983375694f8ac25938b9d8f4a695a9a70cd288b617afb452a8103e3aba5ea2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}ruff check #{testpath}test.py", 1)
  end
end