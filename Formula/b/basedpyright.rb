class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.22.0.tgz"
  sha256 "233d3b6be85699fcef019942fdf865a056d966ae08bed89f7db44da5a6fdfc63"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3c211fd6ed2129c74e7cabf91edd5c821a8e370d897ae362f830ee29344f826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3c211fd6ed2129c74e7cabf91edd5c821a8e370d897ae362f830ee29344f826"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3c211fd6ed2129c74e7cabf91edd5c821a8e370d897ae362f830ee29344f826"
    sha256 cellar: :any_skip_relocation, sonoma:        "5db6efae86f097f9a1e66d882364c1cff4ca76d5e8aee8cad551e910eac9ffe0"
    sha256 cellar: :any_skip_relocation, ventura:       "5db6efae86f097f9a1e66d882364c1cff4ca76d5e8aee8cad551e910eac9ffe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c211fd6ed2129c74e7cabf91edd5c821a8e370d897ae362f830ee29344f826"
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