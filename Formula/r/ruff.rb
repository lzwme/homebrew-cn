class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.7.4.tar.gz"
  sha256 "43b2619d1405188252425db62bea2c989c5a839122e5b562de11bda99ff3252c"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "112be1633b5b52a696c5092d8b45090b0ee5f9c5df53c6e90a7b9fefa891003b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad0a00ea71d261e7376c1fc6fe242b190ca39a7a6bf17c8eec349f169d5eee1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "901804e12764911283b53fb4e8d678ea24dfdbad8623db98aff7c429c34c0af9"
    sha256 cellar: :any_skip_relocation, sonoma:        "02ac392211911143812791fb156c727edafa02f5b2fd0ea32f5b4488b3f0d5c4"
    sha256 cellar: :any_skip_relocation, ventura:       "a4d546488c9a60ece25be8e577ee1ac6de779511a20b48c0c1fcd10a8c6dd24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a30887935bc9b4eabe657b34b50331a77cf49d2627475eda1009623e152e68"
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