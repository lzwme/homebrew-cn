class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.3.9.tgz"
  sha256 "3bb453b54bf5a101df12e98ef0cc9ad121f68530a5f867721133b9155bad7981"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6bd3c0aa846cbe4b7dff1bb8a01af75743f52327c95a20ca85aaaf4e8ff86c22"
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