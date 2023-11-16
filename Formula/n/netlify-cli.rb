require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.3.2.tgz"
  sha256 "0efaa5aa34aafce11a02d27f8a0d42163c3913b2792b61f3f0f3f790026a2f72"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "c03e858ab72d5d257cfb89ad99626b3690286c501cc17356f32296851295a847"
    sha256                               arm64_ventura:  "89af55ef123e7fff9d02e2ff6611fc8ddaffc392c1bcc0e6e09fd61b16b4a638"
    sha256                               arm64_monterey: "159c7a4b332574f337e9699b945079d75e63eb81ec0cdd7f8b4f5c5e164ac296"
    sha256                               sonoma:         "5165d50a1c7782f0325c512e6422e976a57eb9bede7efce7ec9e137d5b94b257"
    sha256                               ventura:        "418d8032d6960cdeafe45b6474a730de790a11b3402444dc9d9b3065abd3e67b"
    sha256                               monterey:       "4735c721a08ed5b61dc8458932041fe4331b3852a771563ad7a5dab007fb77a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94f6f402a726adca867bb0a161519acb3f2cdb804364c9688bd2db181b02001b"
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