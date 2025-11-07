class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.4.tar.gz"
  sha256 "d7a591b4f5e3adc82b511f5437285fce3ecd006117dd4b332023a444f7e9deb5"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae3ac196d70c43a31a14b2071e9fd15267d10cf6b72242ce4706df8ffdcba10d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad196c90abf2f530da2fbad1e4121e7e889b9f720aed72c8ae66776da9f48cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f578f5808e0577c47797624bb8b8eee446abe56add656f54b4e95390801029"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7dd5b5a8d973a1a092148a804c807907b53b9a6b0562c298f95ee84010328ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1abb1863dc15275cb6629953a570cc022d40bcd93fb240f11e4d1f4cd5f24808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "560bace4fbf18899dc4b25a909a6cdf6b811168a05db3b2840c5a55ba07f6285"
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