class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.395.tgz"
  sha256 "905edbc4b77d35a025e03d588dfa56c96b7995d2b54ad54fb8e8d6e1a2ef457d"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef72625f7132ecf1890d30b8f89b1869d0439791d6839102168c110c8d7cf29a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef72625f7132ecf1890d30b8f89b1869d0439791d6839102168c110c8d7cf29a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef72625f7132ecf1890d30b8f89b1869d0439791d6839102168c110c8d7cf29a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fc118074a64225f30479b265654e7fa81ec617df0beab72c2787c07d2eb3e83"
    sha256 cellar: :any_skip_relocation, ventura:       "2fc118074a64225f30479b265654e7fa81ec617df0beab72c2787c07d2eb3e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef72625f7132ecf1890d30b8f89b1869d0439791d6839102168c110c8d7cf29a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end