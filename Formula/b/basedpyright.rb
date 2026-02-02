class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.37.3.tgz"
  sha256 "64b43afa2f87a3bf143a066adf6e67f355c14788d5e958eeb8c9cdfe185eb2a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "126dd1e1cb8381bc8e600d05b15713dae742a1c6dfcd3f192e244ce72a8ecfd6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"

    # Remove empty folder to make :all bottle
    rm_r libexec/"lib/node_modules/basedpyright/node_modules" if OS.mac?
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