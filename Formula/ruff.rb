class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://ghproxy.com/https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.260.tar.gz"
  sha256 "db01b596411658caa63bce3dd5c2e5e2d3b972139d24f3838c18f21ea3529c2d"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e5f6d2e157d204c40d507576ee05e4cbb2f57e5c9e6b8ee7b759c15aaaa1068"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1cdaaa400f2ca8b13c26ea28443fa6df51b9f8616018c73c78ae76e90f1ec3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d29a5c5776bdf01b53a84b6fced12e4b5fc68bdd141e0d2881a4a94abcef54f"
    sha256 cellar: :any_skip_relocation, ventura:        "71bd1665680d1f08561262b5b1799b11ae47f6f753b338193f95950c61dbd585"
    sha256 cellar: :any_skip_relocation, monterey:       "6abbd9f853689ce2b7ab947b944cfc5ebc3263f9573f3bc5cfcfc850155ddb45"
    sha256 cellar: :any_skip_relocation, big_sur:        "a44657e000b7571f8b50f0af258285cabd917a56f480c3c0324f3a8b08bb10ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1bd678e54ce52943ebe2bd35c2e4f21200286a406dd8d7ab1b6a4a7717532dd"
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