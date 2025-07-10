class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.30.0.tgz"
  sha256 "25a02e9691de63be26a0b761de61a9dfdf5c82e240bdb3f4da9ea4d7f7b9c887"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31768b201d47228d05a258e28bf19ea53c0a654a4582641d1562e602eaeb0e43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31768b201d47228d05a258e28bf19ea53c0a654a4582641d1562e602eaeb0e43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31768b201d47228d05a258e28bf19ea53c0a654a4582641d1562e602eaeb0e43"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec776ab046ec9fa7a876764684d635b178dd3837eb8304b016298c3b727e8eef"
    sha256 cellar: :any_skip_relocation, ventura:       "ec776ab046ec9fa7a876764684d635b178dd3837eb8304b016298c3b727e8eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31768b201d47228d05a258e28bf19ea53c0a654a4582641d1562e602eaeb0e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31768b201d47228d05a258e28bf19ea53c0a654a4582641d1562e602eaeb0e43"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end