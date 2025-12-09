class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.191.tar.gz"
  sha256 "01afd6ea3468242907ad42f5bf0b40de02a4b57a61302e52b89cbe24132a1349"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f1280e613df285805ae81485bc067b4fb00f4995462ff91adfa7420cb273627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d18e05d9721812234a32ec071fbe4f9db5a75e1c57f6a49dcb5e517c46919a45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1070ff42ac6ad36c72d03aeb69ee724aeac6f5854e2710888bdb1eb57fb98c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "52a7ba26ba0d40ba623d53acb0ee7b3360f8c720827649090c365de29c27014c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bce45ef5d0262ec1c72695276927674138bceb0c613096481f050b30064a71dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b8fc694aff55d60feb937adda100e29378619c5a62383da9e69cf1b5aed95e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end