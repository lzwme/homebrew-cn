class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "747c52757241cc4ab7840e081588132cf9273b9bc34eaf5eed3dcdb3978e3c30"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4a0609529bced214f612be6f1488a33669634e1a740cdb86fe061028f2af6da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "262df0f11bc6865a2a1985e84e6bbcb998df5022a9675ff2015a32491abd0d48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e1517b4e25ae1fdc3d9a8415a497244963acb333182ae7450865a8464882f73"
    sha256 cellar: :any_skip_relocation, sonoma:        "c10b19b9f28c8cd0aa6796ef8b250506ba35b516ee7dc60206d0e2742c4a01f5"
    sha256 cellar: :any,                 arm64_linux:   "9373b1188c673803d45b201c0bb7fc8685faca260b610bd9c0bd528d123f1f21"
    sha256 cellar: :any,                 x86_64_linux:  "5860b5dfc08106d2bbcfb98808adc1d7a00dd578311f5fcd3e9a1c037ec4c65f"
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