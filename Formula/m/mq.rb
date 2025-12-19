class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "a89cf7588c11a3f4af696db14184e51caa8be1f8afd7d5ad40516dc7876ac615"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "673e8037177a3a0b8e1f627586c9071ddb152db7445e62082bd061cb80809b15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3650ab893ca214fcad498080e824059069c52c871618d6d6e522d1c86d7a4543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a7ba3d5d53a73fed67e53f1607b866b6bdd79dc9b510d1f018dfb7bf3d855dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5acf2c2c4992144dcb6ae53f587ea4e3fd5105899997f9e823bdcccc82cefc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "737f28b8b5dc3de9c78b4a538e132650a01d4409e9315963410e0cf3d5347a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f1a55355bd4a44e6c8ad105d9136204436b53cfe8a35e1f8dc7639e8f44677"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end