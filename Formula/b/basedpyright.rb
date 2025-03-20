class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.28.2.tgz"
  sha256 "0115423b8ee4f94c06351c51cc2221fc8d338b19c80286110d0cbea07b2e2efc"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cbad9738a4334b534e8798b29e93a0fcbfd9dabfeb37f1a2e4b1c64224d4e0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbad9738a4334b534e8798b29e93a0fcbfd9dabfeb37f1a2e4b1c64224d4e0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cbad9738a4334b534e8798b29e93a0fcbfd9dabfeb37f1a2e4b1c64224d4e0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "be7c7a159a2243b6a865864ad4a6bb95f7371ad81ccebc25033401a55183e148"
    sha256 cellar: :any_skip_relocation, ventura:       "be7c7a159a2243b6a865864ad4a6bb95f7371ad81ccebc25033401a55183e148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cbad9738a4334b534e8798b29e93a0fcbfd9dabfeb37f1a2e4b1c64224d4e0a"
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