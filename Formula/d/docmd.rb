class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.7.tgz"
  sha256 "7b5b0272cf25143ddd1797bcbf53f53c1b67c0d4bcf1d7f764f8ddeeeb78d2d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94a84d9fa1faf5f1dd9aad4e8f2beafbb60137fd934bf9c497465242f126108b"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.json"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end