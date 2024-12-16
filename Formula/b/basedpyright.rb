class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.23.0.tgz"
  sha256 "df538ffb16c2bfbb11907b92933713c3c17b0fb7937f0cd61eabfdbdba6fee3c"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "683f1e0ee83ebe1e6b7c41bc678a09484f84e0605de3a9d1b21f9aacd259349c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "683f1e0ee83ebe1e6b7c41bc678a09484f84e0605de3a9d1b21f9aacd259349c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "683f1e0ee83ebe1e6b7c41bc678a09484f84e0605de3a9d1b21f9aacd259349c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a181e6e7cca01b91f642919ed59e3e4f7e6642ed59f949b5640d410be2382ec2"
    sha256 cellar: :any_skip_relocation, ventura:       "a181e6e7cca01b91f642919ed59e3e4f7e6642ed59f949b5640d410be2382ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "683f1e0ee83ebe1e6b7c41bc678a09484f84e0605de3a9d1b21f9aacd259349c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binpyright" => "basedpyright"
    bin.install_symlink libexec"binpyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}basedpyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end