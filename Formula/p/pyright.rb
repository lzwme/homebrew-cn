class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.374.tgz"
  sha256 "a5f7d706de74ee63231b4e2def32ef65faadc06c3eabc61c8213da45e34d34c6"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "457f5b72d67fc8dc57b4d8fdc9f97f0df7285c8303795bdbdb4ba47a841da5c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "457f5b72d67fc8dc57b4d8fdc9f97f0df7285c8303795bdbdb4ba47a841da5c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "457f5b72d67fc8dc57b4d8fdc9f97f0df7285c8303795bdbdb4ba47a841da5c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf8183e6d2e51b1c89f0a033f9ba506b8f638895d368757c39a3fd4d487bc07b"
    sha256 cellar: :any_skip_relocation, ventura:        "bf8183e6d2e51b1c89f0a033f9ba506b8f638895d368757c39a3fd4d487bc07b"
    sha256 cellar: :any_skip_relocation, monterey:       "bf8183e6d2e51b1c89f0a033f9ba506b8f638895d368757c39a3fd4d487bc07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1b4c863e257bd56e019530735f864ebb880300873e0a1ae6c0762db596703a9"
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
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end