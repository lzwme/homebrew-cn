class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.7.0.tgz"
  sha256 "bd20cecf85242afce141b4f3005dea301136d860d3dde161cfe62ddee60eb542"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e271caac65e3069afcd2443572900facbf1c7efdfd0f7ed28409592623d9571a"
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