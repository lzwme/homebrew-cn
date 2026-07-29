class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.297.tgz"
  sha256 "1e7d2eed839c5bc58e0c557c44e05b005d6c301189bf08276e0b9a63c5b58178"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ce042d0ebb09e6c4abe2b6b25d1d2bcae8611cd71696b00483b62b9c18dea43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ce042d0ebb09e6c4abe2b6b25d1d2bcae8611cd71696b00483b62b9c18dea43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ce042d0ebb09e6c4abe2b6b25d1d2bcae8611cd71696b00483b62b9c18dea43"
    sha256 cellar: :any_skip_relocation, sonoma:        "03b16a9516d0b1051bca109f1203d0ab14f1c75285b6a9795f2129b03957af25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88e18a2f71b73af461e09d910e7013a6e0703b9d403aab66cc2004ed0162785d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00c082472605d3924e410a01433aabf794216dcc943a1ff6e7aea439e99143f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end