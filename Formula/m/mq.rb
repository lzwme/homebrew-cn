class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.23.tar.gz"
  sha256 "0a8919619efed18e6c4ebf8154e5d05ba8fd52237d2a43c1139828e581025107"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de62f14b6bd69e50a20ec80d1b016d786e07ee457295de952996bb074cc2fdf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0219c3fb04ffb5823095235cb9d4b7ce6b147be6d4de60919aea798fb8c44c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "136f9c3c5d3e6e737e418d78a8b7861d400252ac82bcdf174a55ead94299ce44"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5827f9ad1c8e8809187fb83e22f19908462d7afd36ef7690e7a0e5adec430d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2570e908feb8fb6a25414ffe894b8029aa3eee3cd7dc50adfc214fdb4fa4bbf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e56f0b72da99ad9087ea91f985fe6b5cdd7c749f23138b10c4d8aa6f9b246f2"
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