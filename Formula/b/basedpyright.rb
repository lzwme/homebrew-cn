class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.17.1.tgz"
  sha256 "82a27e8cc3fbe608cbfb2aa1ff08428bf686a1a08db2eddc2ecb29f8177fe368"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "116d9042bbf40cfbb27b536a943c3d8d927a1946d334a97e5c60fda1492f4851"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "116d9042bbf40cfbb27b536a943c3d8d927a1946d334a97e5c60fda1492f4851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "116d9042bbf40cfbb27b536a943c3d8d927a1946d334a97e5c60fda1492f4851"
    sha256 cellar: :any_skip_relocation, sonoma:         "10d00876d7dbcb50e5187e45ca16b331373707c828a119c6506fe1232d52262f"
    sha256 cellar: :any_skip_relocation, ventura:        "10d00876d7dbcb50e5187e45ca16b331373707c828a119c6506fe1232d52262f"
    sha256 cellar: :any_skip_relocation, monterey:       "10d00876d7dbcb50e5187e45ca16b331373707c828a119c6506fe1232d52262f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "116d9042bbf40cfbb27b536a943c3d8d927a1946d334a97e5c60fda1492f4851"
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