class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.25.0.tgz"
  sha256 "fbc4a28724bad7e8218e1087a7794eb1dc98468ea4fb96c01f121888c6fff0a0"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a62e3834961c2929f6b5e53b86ad967ba0011d48ea02beed8f2325b800b8cae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a62e3834961c2929f6b5e53b86ad967ba0011d48ea02beed8f2325b800b8cae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a62e3834961c2929f6b5e53b86ad967ba0011d48ea02beed8f2325b800b8cae"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8a26cbed1ceb7619bfe7153abedbb4f32397595e99ed7ee1db0858b5dd5a8e8"
    sha256 cellar: :any_skip_relocation, ventura:       "f8a26cbed1ceb7619bfe7153abedbb4f32397595e99ed7ee1db0858b5dd5a8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a62e3834961c2929f6b5e53b86ad967ba0011d48ea02beed8f2325b800b8cae"
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