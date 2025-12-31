class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "a2f4b032e9df72745d2cb21b15a93065a90ca756c86cb5856cc59535ce5d4035"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b3bde9cfe715bb4c1722f94d609aee37bbc16dedefa0c40eb9858d992567352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1251ecb8dc599d19fd31aab1d0deec99ca83b47724aec8be59474a6cfe94e736"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f9605e3bd8f573a83748046846b27e2ea32a377c4aba0b488447b579154129"
    sha256 cellar: :any_skip_relocation, sonoma:        "fafba21859375a71326bf39d04b85d0d8952ce18d30d574802f5ca697aae36b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "321f6da0ebcda999130213f7d7a02e24154fd9676319e98b6983f1ae9548e6d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d67b88e40ed2a0323e0d37ad31a68189238575d4af198c9879effeb4c3851e"
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