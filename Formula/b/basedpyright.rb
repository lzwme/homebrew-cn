class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.28.4.tgz"
  sha256 "e42c5d7bae147908023970752d8e5a2738c98ae7e954074bf114b257abb0b821"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32853221e911e40d549cec4c8a3139ccbb90c04e63fd153807c13fc7cbf369f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32853221e911e40d549cec4c8a3139ccbb90c04e63fd153807c13fc7cbf369f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32853221e911e40d549cec4c8a3139ccbb90c04e63fd153807c13fc7cbf369f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3de7cbfda7b928d8efd784833b28c6d703cbaf977b628c80b86c42bf1c16e411"
    sha256 cellar: :any_skip_relocation, ventura:       "3de7cbfda7b928d8efd784833b28c6d703cbaf977b628c80b86c42bf1c16e411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32853221e911e40d549cec4c8a3139ccbb90c04e63fd153807c13fc7cbf369f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32853221e911e40d549cec4c8a3139ccbb90c04e63fd153807c13fc7cbf369f8"
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