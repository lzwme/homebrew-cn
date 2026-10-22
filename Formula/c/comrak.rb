class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://ghfast.top/https://github.com/kivikakk/comrak/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "06933637b62368dc5a1199dddebc40794ee34a68c4eb47b5900b774250093f2b"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd94dea98183d02cfa6f4e0a8cdde76f5baa037f3db1c548c96eb720ea5e729d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c2c5773e28da62daacbe5dd3cd83a587b37e45cd6b7170a75174db674a006d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33d08cdbbee1dd87d215f579c17a5956716712434a0192be39e46be77a1cf4ff"
    sha256 cellar: :any,                 arm64_linux:       "f6d1ed29288bd4f0ccfc35c3966af9eb5bf1759e39985419b2b8d609f15705b1"
    sha256 cellar: :any,                 x86_64_linux:      "83f4d476e40c04291f783c231eaec2297311ca7b29e68f91a0112d4b1e142c58"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end