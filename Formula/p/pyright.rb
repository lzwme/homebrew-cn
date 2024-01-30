require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.349.tgz"
  sha256 "5be50fa65c854444c523f8866af05add170a42b5b48d98e0fd000bb0089ab1ca"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f87c6d7a1d33ca7626ace35af15bc0e14cc5ff3dd649110d62f51acbc56fbfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f87c6d7a1d33ca7626ace35af15bc0e14cc5ff3dd649110d62f51acbc56fbfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f87c6d7a1d33ca7626ace35af15bc0e14cc5ff3dd649110d62f51acbc56fbfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f2ec6c7596ccd5a3f78e12897750e7bdebd9b2672ad21fb0b36e072b629a3c4"
    sha256 cellar: :any_skip_relocation, ventura:        "7f2ec6c7596ccd5a3f78e12897750e7bdebd9b2672ad21fb0b36e072b629a3c4"
    sha256 cellar: :any_skip_relocation, monterey:       "7f2ec6c7596ccd5a3f78e12897750e7bdebd9b2672ad21fb0b36e072b629a3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40745bffa4fa7f081b1a3f81397c870f02521ed26b83fec9a632f292a92493fb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end