class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "bd1e63bdbb1f6923002158ea01f785f4ff277e2d2e22b82f79cd9e12bb3fa662"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53c3c475d27b97bc272f922e45cd92585de08d0ce137ff8e16fab0bdea18848c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e67854c432382998ea7ed93a58af7f9805746596ae1fb19c68e9d643cb7a3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c73f6d0bb8a3904b02d5ffd61cdd716ddbbc8097b42dd4de43a7ba2fa2647ebb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7621825135fdb51b17dd8a1e23b0c881e8193daf4bf8efc2f702b4dea3254c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68ee537f0ddb04bb3240c179bb0731c4282468b5841fc646195788a34a0e871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8479c47dc80d33be680f9d4abd7e16d92b67146c009be40527ff3096c3816cdb"
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