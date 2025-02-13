class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.27.1.tgz"
  sha256 "53e32194be6082193a80558a994eea5a86c98a36de5be8fd5eeb63dd7b08a221"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "181789b66309915dd81804bdc721dfef93b2c192e9e29d6c80c6f566dca85e2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "181789b66309915dd81804bdc721dfef93b2c192e9e29d6c80c6f566dca85e2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "181789b66309915dd81804bdc721dfef93b2c192e9e29d6c80c6f566dca85e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "467cf2490a9edc397c5b3b67523ddffd9d6e351d6691673a7c62b26bb1512daa"
    sha256 cellar: :any_skip_relocation, ventura:       "467cf2490a9edc397c5b3b67523ddffd9d6e351d6691673a7c62b26bb1512daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181789b66309915dd81804bdc721dfef93b2c192e9e29d6c80c6f566dca85e2f"
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
    output = shell_output("#{bin}basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end