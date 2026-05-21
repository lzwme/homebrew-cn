class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.8.4.tgz"
  sha256 "7ae4f8e64589a1b7569dc27398870b12251a688023876b10f58d4a3d8502b40c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "84988b767b9efbcdfccfdc65368eaa20a005d4deed9643531ec44945a939d9a4"
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