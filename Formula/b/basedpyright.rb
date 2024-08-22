class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.17.0.tgz"
  sha256 "fab05665048eff8a51746ef9ec0caab423d08ba0eac1afbc17564c46ee53a219"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b094068117b6a0fe6957e4d0ebadf072e246baa94dc93231fdd126dfae05c508"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b094068117b6a0fe6957e4d0ebadf072e246baa94dc93231fdd126dfae05c508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b094068117b6a0fe6957e4d0ebadf072e246baa94dc93231fdd126dfae05c508"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f48dbd4935389d20b8ee93e58c8e8b1d1bfd69f062321039cd8ecdf6d3d603c"
    sha256 cellar: :any_skip_relocation, ventura:        "2f48dbd4935389d20b8ee93e58c8e8b1d1bfd69f062321039cd8ecdf6d3d603c"
    sha256 cellar: :any_skip_relocation, monterey:       "2f48dbd4935389d20b8ee93e58c8e8b1d1bfd69f062321039cd8ecdf6d3d603c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b094068117b6a0fe6957e4d0ebadf072e246baa94dc93231fdd126dfae05c508"
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
    assert_match 'error: Expression of type "int" is incompatible with return type "str"', output
  end
end