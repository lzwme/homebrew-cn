class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.17.tar.gz"
  sha256 "ecbf2ec04c50441cb75b5fa18a5b477b6740efdf3f2eb5307c1896f453509c3d"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cd183201c8e394eb026a3833dd4b1f574bbe70077ef52674c65b19ca5f4f507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f5062497cb53d9082a03e75def24b40f9d852d5fbc2b46d3deaea3dc41bf95b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "296bedd1696c0266ec0e22eb73e4780643c88a746b60be2e877548450355df3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a2dcc7b5a74d457eb87396b3f7a09c8c3a1563419dcd9d40659c00ca9baf1b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07341ffd6171218de92876c3bac2a09c03a29027cb20c8ecbd57e3a66a5a522e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfee402e53082cb8a2e85c715bab7e22ac8354d61378d91a882ac4dbcc057c2e"
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