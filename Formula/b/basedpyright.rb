class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.22.1.tgz"
  sha256 "e27bbe53f853d9c62ab6d9cbcbda9c8a7ea2632b3d25df26b66d2b50a6312da7"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b20fc23ac4b40d6a9a023381e93517d70fea6dfa24e9fa9afaa8dbe984787b83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20fc23ac4b40d6a9a023381e93517d70fea6dfa24e9fa9afaa8dbe984787b83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b20fc23ac4b40d6a9a023381e93517d70fea6dfa24e9fa9afaa8dbe984787b83"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9bb4d5edad4da68e65cd15639972d2ff5b4cb6b788abec5bbf05345be68c116"
    sha256 cellar: :any_skip_relocation, ventura:       "f9bb4d5edad4da68e65cd15639972d2ff5b4cb6b788abec5bbf05345be68c116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b20fc23ac4b40d6a9a023381e93517d70fea6dfa24e9fa9afaa8dbe984787b83"
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