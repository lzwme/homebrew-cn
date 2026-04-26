class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.7.3.tgz"
  sha256 "34c50605719c8a6734979f255ecf879bb914233bde9b5071ac502bea1a838c48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fcd70a1eb427c2af89530b3623f931c917bc8369cfbfd18a21b733f6d9b9265d"
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