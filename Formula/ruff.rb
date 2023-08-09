class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.283.tar.gz"
  sha256 "4c79a2e527937a01ff7c6c47ee203d8e894c50e37f7d899d40de2a073bb50243"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "237537901fc9c90db13bd84df7be011fbe51842978705e4763d7f6384ede0e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c815d7f5f832f42022a45bcd895fb8565e2c790625a66041dc069410d1df172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76dd67a7d7b7e92d61523cc337383f2ff1040f46844a2d9c8940cf70e0d106c8"
    sha256 cellar: :any_skip_relocation, ventura:        "8cd471e90cbb4aa8ac6a154f6a3e634b2dc3ece8e80760606d903d7a5b69da84"
    sha256 cellar: :any_skip_relocation, monterey:       "99572e8d119783f6e4df4c0e2e146988b39e9395c494315976a926b6f446a3ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf1c1f4329d6a2f7c641528c023ffe22b83595d1c8026c0030b2a0c11595f425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17026b17b0188860d0bdc5c07115e825a30a7e2e7551fe23072aace88612af9c"
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