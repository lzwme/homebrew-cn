class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.5.1.tgz"
  sha256 "45ed7456d6a33a6c8a22091256935a0109ec0369729402ee7afc74a656461ce3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddcf4279962b7bbfcd4a00929e56b2204da917021983ab27bb3367eb2a8c0f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6700e4c48367254a453204e18d9fcd251a8922525894a4464ee7f953a88c4ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6700e4c48367254a453204e18d9fcd251a8922525894a4464ee7f953a88c4ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c4b0f2bc34fdcd70a69a8d08b0182610b123bca3a7db8af8612cd10722bd968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bfc51f86292e049321ab078f71b41d288a4f4042ccea0ec1f29e1289831b2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bfc51f86292e049321ab078f71b41d288a4f4042ccea0ec1f29e1289831b2f2"
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