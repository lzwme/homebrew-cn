class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.16.tgz"
  sha256 "5632531b808c0274e3f80f2511f744518cef674956983e3b918ca1e0ebee31fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "abcccb6439c5fd36fc1e4f6e13df36f43ed817a50c74d32f7e44c8388a56ae07"
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