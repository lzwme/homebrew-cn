class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.4.5.tgz"
  sha256 "2de17aee4cc0038805f535ed428f7d44bfb8c7e5badd0d5c2f77903541152df4"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f96199a1354534ba06fca0a9268431fa93d0aadf3fb59acb7e5a5795d6805d21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a28f1b8fa1292af2e08a60965504f420feaa9c66fc33c639e30bf0a40c3c67ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a28f1b8fa1292af2e08a60965504f420feaa9c66fc33c639e30bf0a40c3c67ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "826e120a71f8a20998477d998a6ae9ffbcffb1e240efd6a77134b79eb2e5a289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "897fd6f73b83a48f892009e5672221429f829d360e85f010b461d983ff287cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bd0bf529ad040715efdbf216ed4cc6b4506ebbad0ff399d7f317c58b108e5d7"
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