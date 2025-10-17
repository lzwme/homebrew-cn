class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.6.tgz"
  sha256 "6dadb99f5817b39ebe954bffeec256f0df4dc1733e29b6aa36dcec6548fd956f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7f6308e8ba6e66f0d3cfbf26dffcf1ff6b3c0757335c719d432f13f37dc8c6b2"
    sha256                               arm64_sequoia: "7f6308e8ba6e66f0d3cfbf26dffcf1ff6b3c0757335c719d432f13f37dc8c6b2"
    sha256                               arm64_sonoma:  "7f6308e8ba6e66f0d3cfbf26dffcf1ff6b3c0757335c719d432f13f37dc8c6b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dc3edd63f1d36f6b8d7db33f0b6605ff7a0fa3fcd8ae0731a7c21f289ab9176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2889f6355080370e2b5475ad4aff879647292a00706c2361748f9ff5aebc92de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b92774861fe031b3d97fd3d40a78980dd0183fde5c3e069ca2c5f68368d5cbfe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end