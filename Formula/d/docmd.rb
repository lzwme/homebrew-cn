class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.7.6.tgz"
  sha256 "24238fddb1afc546b1d0d88b3d6c42c9bc9b61e0acfa494f6b3a153439ccae66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9317e18b02653368fa7c50710806ad582c6c0b118f0e0b0ac75fb267995cde17"
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
    assert_path_exists testpath/"docmd.config.js"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end