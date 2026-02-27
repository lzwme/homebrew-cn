class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.4.9.tgz"
  sha256 "0c80fe7712b31acb402e18da6d82d16d3c255ed51ab5f50159b29db7581a109a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bf718395805658706562fce9249caa360174ba4332e2b777b0554815a30e802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "478da2d0d0d82a2c7349a4e50218218b99c12b23a35ab8b0771c22d49f598778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "478da2d0d0d82a2c7349a4e50218218b99c12b23a35ab8b0771c22d49f598778"
    sha256 cellar: :any_skip_relocation, sonoma:        "dde61d949e7d1cf20e0321ac92d9b364a0e93976bdd83c0aa8521ab0ef1df497"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13136784da7f48798d8fa3fb9b1430c66f443f0c9ce55d16d80be5d862e4c8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13136784da7f48798d8fa3fb9b1430c66f443f0c9ce55d16d80be5d862e4c8e2"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@docmd/core/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

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