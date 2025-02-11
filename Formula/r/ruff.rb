class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.9.6.tar.gz"
  sha256 "18e292afc72f05228b5ab27b1c69763be3e0da3222e3d4494dad9f889178edd8"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99ca35c9a0975cc808db03e4a795dbeb97e3ba2cf5806eca31d5be9b6a10a7eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42aa6912566837428f207a8da53819080102f500ea51455283b325d1e5c9f499"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ba27b5b084a04d2a2417eafa21156869df68c9ed31356e97dc551e752c952fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "90f9fd8a2b5ca926781209e0b4aa983bc21919225a238935f056ebb80b00bec4"
    sha256 cellar: :any_skip_relocation, ventura:       "7bbb4d329e0173797c96bfe67c56775747d42f57b428d61d07f6f6f797661854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ac904b2fdaab3a25bc85175191519857202b495afc571080da7231313d4ddc"
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