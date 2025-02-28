class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.9.8.tar.gz"
  sha256 "e992c50a540a64cacf64b8717d596832aea43ca8dce4bcfd3b551f9ad05fa97f"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "279ce70f82b40e950bca02427c8f282a7d67d700bb4654ba94d925eb503ee714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f76e5ec55e888e2a1b50718de6f378a2c9d9cfa31a1def3b65cb862dd7e8c729"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f60cc2e5996cee30b588594ca060509f6578ab74a6125dd8aaa713c59efb90c"
    sha256 cellar: :any_skip_relocation, sonoma:        "644905e0a3d32960ef307caf07a28e435cdb36125d1c2337939efdda5ba0798a"
    sha256 cellar: :any_skip_relocation, ventura:       "0943c569f1655f5a7069ff8daeb12bc9908af989f8b945ef7dea09a2acb38ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19b8bfdb8752c6b2db5f967b22f0a24996c453a5b76869237d94920bdb9aea48"
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