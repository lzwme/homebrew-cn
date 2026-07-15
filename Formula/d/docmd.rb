class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.13.tgz"
  sha256 "a6404fa60968543002894aea41be96213c71767c153c1ac25055b4d322150c73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5bf6a6077048e6cfd2e9227713b604a0a409ec29229dbaf64079191766f3c48"
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
    assert_match 'title: "Quick Start"', (testpath/"docs/index.md").read
  end
end