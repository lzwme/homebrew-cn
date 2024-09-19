class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.381.tgz"
  sha256 "7d7e531f21c5a7869dfa792bc1918e6ecf857a6fbf128aa4e163d18515dd8828"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b557e1e647cda35f187510132ce71a47f03238a608b13f5480b302cfa7b30c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b557e1e647cda35f187510132ce71a47f03238a608b13f5480b302cfa7b30c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b557e1e647cda35f187510132ce71a47f03238a608b13f5480b302cfa7b30c20"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd6a9d7dfcb033e5c3c4b904cbf78d33cd5e4079407edc9bccbaa87c5296adc9"
    sha256 cellar: :any_skip_relocation, ventura:       "cd6a9d7dfcb033e5c3c4b904cbf78d33cd5e4079407edc9bccbaa87c5296adc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b557e1e647cda35f187510132ce71a47f03238a608b13f5480b302cfa7b30c20"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end