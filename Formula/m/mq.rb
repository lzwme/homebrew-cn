class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.19.tar.gz"
  sha256 "dbc57fe636d34b8acfd9b983781912a4304f92ec876b6e58e00f931a8112bd64"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c089c5592807872a31b9fcb8a75b75daaba14dd07aa6ceb8ae6acb85244473f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af064fbb54b88ba7a4dfd097bc8fb8a56903c3f838224b7ccf69451bab00b638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "609698cec6c0529266f0446560c6b1b1f0985c9e7d3fca18a0562ffaab027488"
    sha256 cellar: :any_skip_relocation, sonoma:        "f073e0181af5a57af448484f88efaca29c4b2daca6308c2ac1f0eadf7354c3db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7acfb5a4bd7b34d60d5c09f718967864d5646723e039fe11ad3d3a56d2160241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ea9d642d181c3b3ca8d19eddde1db707b7759978bb91021c253e91ee973aa6b"
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