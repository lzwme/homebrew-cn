class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.12.9.tar.gz"
  sha256 "676e3c1fe6b73fa76273796a623c8e155e3426311aaa86ce0ebebea57c67dab3"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f28c830d56b654a3c24b1fe206e19c83268b2dde87ae86688e41c9e91df6aea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbad443fa17a25875aa1ab4b74a2cdf377cfa0d76e4be0d798620fcaaffb8c14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6246c060b5bdc5f00c3499f85b7fbe29a4f47522e1dcbe9e54dd099edbeda4b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e7eda11513563bf67d3954ab8abb54b8f83c49af021657b2a189b2c6794c3a"
    sha256 cellar: :any_skip_relocation, ventura:       "2e13f9d52fb6ec1a2b8f6c5be02ea364b9aae0d70ac1f62cebe60c38ff5d0670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b842edbd1fbcf0d1c2391d087d9868115f381426ff153524662b1b68e6281a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76a71fb1bc867340ec69eca57323d1985d66c04ab16c8c5914bab6bb6880a04"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end