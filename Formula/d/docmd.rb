class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.3.2.tgz"
  sha256 "97b30febf58c1a1ceceb117dfc8e237e8e332f3c26420fa248397d41458c3dd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f3d3e3f3f3e4cb8e9f2d5a2a6e377593a6e1b7918ea9774e99d29e1b58c17a8"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@mgks/docmd/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match "title: \"Welcome\"", (testpath/"docs/index.md").read
  end
end