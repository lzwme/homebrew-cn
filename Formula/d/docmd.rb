class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.6.5.tgz"
  sha256 "e54a49cc725c528f761187851b18bfd554b69d078c808d35c5a006835d4d8c12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5654fddb2a9a8b030201e830ac90511a300b58e86227fc9e56438641530cb780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ebccec43de01538c7ea5ce2ffa145628a9bd2d6c410af9f4e51242eb6a4fb5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ebccec43de01538c7ea5ce2ffa145628a9bd2d6c410af9f4e51242eb6a4fb5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "53f085db2926573892b8e22d0fac36a6d45f45f62364bb1cb3509810b83c810a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69d843682b59d636c4bbc746a9cfb3dc4716c706c5516268b21763c3a5ff5f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d843682b59d636c4bbc746a9cfb3dc4716c706c5516268b21763c3a5ff5f12"
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