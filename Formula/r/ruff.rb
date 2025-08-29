class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.12.11.tar.gz"
  sha256 "f8733d281c4d9f33742a94f01b3fd85c2d7ea20a8417901ba534f8241d906fcc"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f9780df4922a34a565c1a0b73b082a871d83b4bd4a7cdc2478eb3e33879919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0e8e1f3a556e955c1a078d47e31899021d7e9fa1756ca79e93432a301234c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b9861496b21f03d94d799fd73a5b630f40cb39c5973ec868df4a581ffbacd3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdf2d10e0fc2ca46c8b8ac1a66269b7449ad3cdae3940cf63bad5c45eec55343"
    sha256 cellar: :any_skip_relocation, ventura:       "c027d70a6bc633049c1d60fc61eca7a0a7f6e211862f09d6741c66eafab6047f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "916ca877a21c302c23b73de37ea96fbb096d7a2c3d8fc5105448c20b602933e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "200da14f8d7f61f61e4d0372f20155c6ade85f1ea82b6b970886fef57e901c07"
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