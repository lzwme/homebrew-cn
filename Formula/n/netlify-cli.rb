require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.8.0.tgz"
  sha256 "498692eb158adf895a602cfbb61e4e0be1a2363d338db66b7386b68c15fc8ea2"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "5150bf97ca891b253bbabfb6aec8f77737dc43117ab0e96f319decd647476924"
    sha256                               arm64_ventura:  "283b2e3897b48f8dfab9661a9308a94c099c1089e02dfcb65ea042167912bba9"
    sha256                               arm64_monterey: "729bb5cfe4bcf85ef48818244ad724b13ee26335e8c56c132f6a3dbf8c899fb4"
    sha256                               sonoma:         "34fd9640a1cf1badba30ade00ca1e90c01019262ac2cd0f6b7b15d0402cf9a66"
    sha256                               ventura:        "05036114682a488e2adc6e7c8df1204ad31258664bd9baf2901b5deac98e28a9"
    sha256                               monterey:       "9332268db6d8d33e3da7871e6cb7cc6a7bc499e51f6a2e8dccd0ba43985e2ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1470a81869302776b85a53d752de996fa31ebdab4404b71c27f4851b9751e80f"
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