require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.368.tgz"
  sha256 "521e4b70cd6dd430717921031a6736e24e1f7ea1ce2921a55c24afc7216370e3"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b12d973ec64d723a9654895d0e3af9a42df52b5b983c0dfe43e4ec4e8f688fe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b12d973ec64d723a9654895d0e3af9a42df52b5b983c0dfe43e4ec4e8f688fe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b12d973ec64d723a9654895d0e3af9a42df52b5b983c0dfe43e4ec4e8f688fe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6456bc07bc343236d96fd58f7126da16039fda710c186b9e810c48ad721f0152"
    sha256 cellar: :any_skip_relocation, ventura:        "6456bc07bc343236d96fd58f7126da16039fda710c186b9e810c48ad721f0152"
    sha256 cellar: :any_skip_relocation, monterey:       "6456bc07bc343236d96fd58f7126da16039fda710c186b9e810c48ad721f0152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac65e356442ec0e637d0631cd27480ad6c7d4e4df1d0fa0be10948343005f71"
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