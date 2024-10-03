class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.18.3.tgz"
  sha256 "19440773c73be993e619ebae6007002f80f286ff24dae30e522f0e70eb89e8f6"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec77e73c8bf799317dfa65cffc7f3b30c5fde282da1ddff5966570ab2798f0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec77e73c8bf799317dfa65cffc7f3b30c5fde282da1ddff5966570ab2798f0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ec77e73c8bf799317dfa65cffc7f3b30c5fde282da1ddff5966570ab2798f0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d711ca19d1e4bc113847181741e945c05178d440855431aa7611f67393672ae"
    sha256 cellar: :any_skip_relocation, ventura:       "1d711ca19d1e4bc113847181741e945c05178d440855431aa7611f67393672ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ec77e73c8bf799317dfa65cffc7f3b30c5fde282da1ddff5966570ab2798f0e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binpyright" => "basedpyright"
    bin.install_symlink libexec"binpyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}basedpyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end