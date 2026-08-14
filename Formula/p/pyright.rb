class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.412.tgz"
  sha256 "b6345cb7253d1f3e311caa0ef17581dbac5b125c42d148667c84d9dca2abd50a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "893e12f33705c773691d5bd7c55afc31376fe058704291d4780b7a51a2c68eda"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove empty directory to make all bottle
    rm_r libexec/"lib/node_modules/pyright/node_modules" if OS.mac?
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end