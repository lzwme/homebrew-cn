require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.2.2.tgz"
  sha256 "3f61666fc7a456e1946409aba82176cbb46b66d7fe7d3670e88fec294550866b"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "d2c745c326f773c7f4e2bc125056c0ca9d5292295eb9094c561de6652a8220ab"
    sha256                               arm64_ventura:  "004ac693bd558bad728a85781ac11ab61590096901fc80bb88e54059edcb4e1a"
    sha256                               arm64_monterey: "ffdacacd9e348ef398739c85ff41474416c9b05bcc61d28a22442169eb937cc7"
    sha256                               sonoma:         "2d9a120666f30efe59ab0b72cdc7200277e7139c14fe5ef2f57f8e7f0fecb9f4"
    sha256                               ventura:        "d5d6f7c63cdf0ee94b0a1d370d0db79a741c12b68ec7cd09c6e90701cf080bc1"
    sha256                               monterey:       "f68eb3d0151f92278fe5c77e3f950a217b3c7d972f991d82917e2b4f122cb906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cf0375d97c6875cf09b76d7cfec47f25fb007c0997a29ed4efd1750ed6414bc"
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