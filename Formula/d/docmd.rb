class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.7.9.tgz"
  sha256 "00b1f169c30937c9c89496386993da18c23c6564a5d2b02e62556532a9ba59d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03b3ca6ebcc62d1a695c7d7669d62ef1d5726d4ef7f72d658bcd796315473c5f"
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