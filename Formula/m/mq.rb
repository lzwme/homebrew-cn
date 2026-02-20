class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.16.tar.gz"
  sha256 "3297318238d368c0b0cd3a796098ed7f9b35ad5e87e5d4d34e3e45bab203d3d6"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1394bcdcc90e31a410eac04e6a22070b2cfaed13471a274dc78a23060a9d74d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d172cd0f04ed107b40556b3db633a8821b0a2886dfef31d7bccbaa82c4e8ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62641ed9b429494f5436ac7c9832426f64a1b106fab311c5efb607b44ded8742"
    sha256 cellar: :any_skip_relocation, sonoma:        "63944096cff38a2999247df87655c9ccb14f600b26b304e4929bb6354950bd92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddb28dfbb1282514aed84bb8427d72314bfb713691ec072e031a73bc47ed4da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22baabcedb2f0d0780aa1ab05f60903ad52c8b2d7348623e8df9baabb876ec5c"
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