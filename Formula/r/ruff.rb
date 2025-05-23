class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.11.11.tar.gz"
  sha256 "fcd8fdd349559421494b653e53a2fc6441a35e51d2992af035c5e5c84e060702"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c331261bfb1275c0939391a72ac483b0691b696dfa9b21f1b4c9a2b6e0ddc5ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50fa499f04d37a02ffa5079bc9d6a6302bf4b43dd30452dd88b06616fd24a89c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97d22b815d65767fc8798ba2384f4b8d88a83272f71344764afa080f1aa3f5ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "5139ed073c447c796490a8e05f38561f09bc77edcab3946da3dea9f4e7c96a85"
    sha256 cellar: :any_skip_relocation, ventura:       "1550bf4fd06ef4799290054968e7d5f181f2d1dfd4dcc14358a6407bc6112ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "054aae9858b4ce1ba1e76fa691d07a5ab906afd7502f8ece8d09077d4343a273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492ee6f64366ab9f725e29bd8dccf1416f18562514c9dae259bd089cddb93562"
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