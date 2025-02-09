class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.27.0.tgz"
  sha256 "a8a980dae5174c42560a8b24798f440c000570fbe61092c4a5237732ecc9a15a"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00d36a279e0ae38832d72ecef02d79a0c95f4ad6661970a4b419242e778d9504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d36a279e0ae38832d72ecef02d79a0c95f4ad6661970a4b419242e778d9504"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00d36a279e0ae38832d72ecef02d79a0c95f4ad6661970a4b419242e778d9504"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e42a46b71d74134c4fc0c03739e57b4f7d49d2698047e57f5a31fea6b3d2270"
    sha256 cellar: :any_skip_relocation, ventura:       "6e42a46b71d74134c4fc0c03739e57b4f7d49d2698047e57f5a31fea6b3d2270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d36a279e0ae38832d72ecef02d79a0c95f4ad6661970a4b419242e778d9504"
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