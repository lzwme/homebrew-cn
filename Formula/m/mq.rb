class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.24.tar.gz"
  sha256 "950260f86e8b1879122f04378dea69b6af1d7c4581ca40f227c5a30847f32dbe"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "392bd9ca4b61df5dd554cf67241e77c2c4cd39fb99bf5a7f6c7b3fbb9dff1f18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a5ff20f82379b95f4ee451cb4f78d097a470c1076ba07230f7fc3b3748c89b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f33445f25d98dd643b7bf38a907ebf130771c24eb0fe0e79b0753b5f82c108"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd0edd12d4f1e2233411639ab1dbc3c2d8e6c8d0f765bd6ddbaa58e34837e2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b2025986a49bdf80eececae081ae5a5b8152715cb64909f5cbe7373b36dba71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a320732417a130a35d61f6d8e58538b1b0ef2aab2389e6d1acd87c02ad2d167f"
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