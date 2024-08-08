class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.375.tgz"
  sha256 "a7b064ac82052fe13e16e91096c247af7dfdbf91322d0075a2b03fdb29bc4116"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c843bcce2e8f96108828025a3b3e8fe7e7cc143f8f2a33f0c3489e0079c18508"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c843bcce2e8f96108828025a3b3e8fe7e7cc143f8f2a33f0c3489e0079c18508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c843bcce2e8f96108828025a3b3e8fe7e7cc143f8f2a33f0c3489e0079c18508"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff9f175ad88445f06998e26247d1a7caa662fa911acbeee01f826d3d0d4b11fe"
    sha256 cellar: :any_skip_relocation, ventura:        "ff9f175ad88445f06998e26247d1a7caa662fa911acbeee01f826d3d0d4b11fe"
    sha256 cellar: :any_skip_relocation, monterey:       "ff9f175ad88445f06998e26247d1a7caa662fa911acbeee01f826d3d0d4b11fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c843bcce2e8f96108828025a3b3e8fe7e7cc143f8f2a33f0c3489e0079c18508"
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