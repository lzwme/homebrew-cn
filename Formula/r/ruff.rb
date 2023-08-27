class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.286.tar.gz"
  sha256 "e2e1427442cde76d16d655f1743a64489337d1864c43540775f64a0456ea0d52"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1633a92f8c8893890e282ed73f60d7075369b77911ed2233cccfa384934d9344"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0c822e061f1fc9655d219be13227089be7eb0e76ca4e2622611c20660f6a593"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a89a9e48cd6f35f07efa5b62836eb245d3ac554342747885f48687ba9f01602"
    sha256 cellar: :any_skip_relocation, ventura:        "f9170f37903ebc54f0593162dcd8c833dfbe0bf9bd3eb0290ecfd758d9064452"
    sha256 cellar: :any_skip_relocation, monterey:       "ffdb3d697a79e35ecc9fa6f96ecc96dda15bb1554ce4761ceab8706211164a39"
    sha256 cellar: :any_skip_relocation, big_sur:        "da570919fc6ead326929e1373153ecb35591b8424582b5f8bde51542d6afa8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ab9ec7071cdc0a4d411345208f47a5b2931b7f5896baf34c3e1c85e521ab61"
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