class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.31.0.tgz"
  sha256 "05391cdff033634b37234ecd8331ce238479f1c331afa95fa95bc494b104e432"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18e8de81c5058a34215e34a28489d9b2beaa91c94d8e5c0140553edf664d1efe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e8de81c5058a34215e34a28489d9b2beaa91c94d8e5c0140553edf664d1efe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18e8de81c5058a34215e34a28489d9b2beaa91c94d8e5c0140553edf664d1efe"
    sha256 cellar: :any_skip_relocation, sonoma:        "38cdc47202d9fba2aabdac40d3d662c6863fa5de6387fb0174d1d2d2eade025d"
    sha256 cellar: :any_skip_relocation, ventura:       "38cdc47202d9fba2aabdac40d3d662c6863fa5de6387fb0174d1d2d2eade025d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e8de81c5058a34215e34a28489d9b2beaa91c94d8e5c0140553edf664d1efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18e8de81c5058a34215e34a28489d9b2beaa91c94d8e5c0140553edf664d1efe"
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