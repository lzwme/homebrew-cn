class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.3.4.tgz"
  sha256 "ca5e453021670085297927a8d0cd93fc6826779b40dea4b96d37ad045acfe50c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4df122a63b020e2e99f3cff666dd96b33c2ccfe65e315af089dbcf00b5971bd2"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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