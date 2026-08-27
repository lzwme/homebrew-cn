class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "df0033bffa4886f927640d93f0aae7b175bb45b5de43b60cfa69924eb83a32bc"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f6bb10864d21d8684acc7d463247efffeba328b4cf674604c8d155c4532662d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e26e4d03c78887d543e9f2b55da9677d9995b381b8e414a20112caa8563cb0ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "546230ee6e166511d3feebcb7a0bd721163bc5adae268d55c22ce82c92c720ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "44edb9656a6badb5854a6886d9ce80e447ef96f81bfb5bc7774db1ab34aff45e"
    sha256 cellar: :any,                 arm64_linux:   "db35d5e0fe138797a373925b7aa8b8559d28d8f333d6ad38612c4ba1c278fcfc"
    sha256 cellar: :any,                 x86_64_linux:  "2348b6eca33f7176de6116ecf08cd59d0017bb3fa9606fa617d172379ac5c560"
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