class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.30.tar.gz"
  sha256 "550e7ee41cba846c4249d4d7c79b9c868bb4889a451581f3186e0dd01ab152d3"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67c23e7ea66cfadff1a0e801e253d74a803ef19ed26af58af6f9e4b65586f622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24c5993130123e16587b9d7e30668412ba5b2a3f5a3c5af99c3cf11dc4ffb20e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95c712fa57d92b6968e8d33e54157b7e248f47fdd347fcf846a2c63b9e0fc551"
    sha256 cellar: :any_skip_relocation, sonoma:        "4132e7aa251c05ecce56d58f88cba4733d6e8de4023312f3b7f6e5fd147ed133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38596b2ecb12da8599332c09c165e91f0954f9c8bec0e11ce8dabc7b8c78e74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5450e8f2f1c12948fefdff746859f9667a2fd8e6c0e98b6abb54612da7b903ce"
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