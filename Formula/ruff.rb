class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.277.tar.gz"
  sha256 "8330d1560841c3e4910766d6dad3f5a9df9803946746c90ee365d82bedc61593"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc73012cab56c448af77ec4fa53833d3a61ef652c6dcf0c94f799c95515795f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "476d15eee359812e63d44fec67ebdc50aeff0778c40e9f42a2050e09e5cb5d33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17299343813f303d7783c53b7c2c6f550c213dc2fcff0a7728a2b02cba995d41"
    sha256 cellar: :any_skip_relocation, ventura:        "01b3a32309681b3b407bf5f6e44273004a544f990ee6ad6de77f72d948deea46"
    sha256 cellar: :any_skip_relocation, monterey:       "16f1475f8da857522acd44618e8615a982a5ec0fb2de42f9e65000545f2327ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ee51e9ee4bdb54a546f3b625f971b84f82d83794e7b8d2394c2e03d7973950f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a3cbdba274e427a3e8e8b892f724a57b0ed2013a572104f3941cdfbda424a7"
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