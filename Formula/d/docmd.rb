class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.4.6.tgz"
  sha256 "57629e10a801d9591317d2bb56305c445f26cd9c0c993573e43ada54035dd2a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "380e0fd2235c2e14c0d3ca79c755c288965206c558285bbc185524ff21853237"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0eb06b92a694f2ecf18fdb17d2ded3daeb3bc4ff310a5a205655facd4fad682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0eb06b92a694f2ecf18fdb17d2ded3daeb3bc4ff310a5a205655facd4fad682"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d8d9f3798df1559bd3ba81854ea6ee7f163b3a7960c7bb35cb7f515d8f8ebe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad3cd437fded1a7808df9c645b7a35c3093c0d91314d0f3bf6bc6ac3f94c9782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1c9fe9a125e0782736e2ad1aba60f1a6f239abcde58f8c6bb71d417be8cc2a"
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

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir)
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      ln_sf Formula["xsel"].opt_bin/"xsel", linux_dir/"xsel"
    end

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