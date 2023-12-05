require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.9.0.tgz"
  sha256 "4104d83c1b60bb2a9eede693e4cbb430b24c69190336dab9cf0bfb1a1de2be71"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "fc6f81cf0a49c4c7c546c94943ebd2c2c2641a005a2952d7c868ace57cb3fee1"
    sha256                               arm64_ventura:  "9a23aca6dc72fd141f193b9aecaa093a41ed216bfda6ae69efa2cd29d02f946d"
    sha256                               arm64_monterey: "8eaf7732dce4be2016b3acc440ba03281d74aa4ed9cd675a2216be56d772864c"
    sha256                               sonoma:         "4ef7dff4be2d1c3595034ce98d9b6fa6a6d852ed028023cafc8f6ff6b016a7fb"
    sha256                               ventura:        "407bbdfa6b76d4aab206e7ccaf03e2be24e484d5945310b928cf8a706d178ba0"
    sha256                               monterey:       "d7eedfff31dc1833daf4806b57b5200a1374e27f28661904353ced7919a4b67b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87aa6e7fac92b52cd734ce5a911b2005cc431b032e097dc428f81cd1f4b7f73"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@parcel/watcher-linux-x64-musl/watcher.node").unlink
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end