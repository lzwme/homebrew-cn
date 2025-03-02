class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.28.1.tgz"
  sha256 "96253236d147afaf4ebabc19ea7470aca87bfd334cdcd811e08250db73ab184e"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72774842a047eaf51b3bcbda29ceda443251d6402c39b3bd09db50918638c99a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72774842a047eaf51b3bcbda29ceda443251d6402c39b3bd09db50918638c99a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72774842a047eaf51b3bcbda29ceda443251d6402c39b3bd09db50918638c99a"
    sha256 cellar: :any_skip_relocation, sonoma:        "368ff6710083fbb78c71368c8eb36abbc4a64b736ce17a6c58cebb20d69586f5"
    sha256 cellar: :any_skip_relocation, ventura:       "368ff6710083fbb78c71368c8eb36abbc4a64b736ce17a6c58cebb20d69586f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72774842a047eaf51b3bcbda29ceda443251d6402c39b3bd09db50918638c99a"
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