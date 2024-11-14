class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.21.1.tgz"
  sha256 "ed6236b524b17fb2e34f3f7502e47334e932762ff3631879388c296d184775bb"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5ffc0dc2e9c282bcef88432539c46636f761e87606bfb007872fbd4bcdf2e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5ffc0dc2e9c282bcef88432539c46636f761e87606bfb007872fbd4bcdf2e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b5ffc0dc2e9c282bcef88432539c46636f761e87606bfb007872fbd4bcdf2e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac43537e62bc3e0a0b466d2467e972dbacbd4e19552d9530dd434f4f0915a97a"
    sha256 cellar: :any_skip_relocation, ventura:       "ac43537e62bc3e0a0b466d2467e972dbacbd4e19552d9530dd434f4f0915a97a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5ffc0dc2e9c282bcef88432539c46636f761e87606bfb007872fbd4bcdf2e3"
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