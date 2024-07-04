require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.370.tgz"
  sha256 "60d79fd7be49d2f545358dba68b72f75a00eed6b664cff188af05a3ff0d85a9e"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edb395366f3236399ab4ac1a7ceea9b6551f1b05f4fda152eb49332ad6cc7486"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edb395366f3236399ab4ac1a7ceea9b6551f1b05f4fda152eb49332ad6cc7486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edb395366f3236399ab4ac1a7ceea9b6551f1b05f4fda152eb49332ad6cc7486"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ac416e6e56c08a595104e38105270f723d9f479f53d29194d6d4e899c01b4cf"
    sha256 cellar: :any_skip_relocation, ventura:        "5ac416e6e56c08a595104e38105270f723d9f479f53d29194d6d4e899c01b4cf"
    sha256 cellar: :any_skip_relocation, monterey:       "894b1934e32d5bcb6f1e516d476e34a6503eb7d6c15ed7db73450e3a2e0766fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a849c016e1f5a7873de52bf56d034bc1c93cd696c06c3b905af50e39efbda6cf"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end