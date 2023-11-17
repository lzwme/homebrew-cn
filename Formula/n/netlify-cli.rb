require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.4.0.tgz"
  sha256 "b69393f1454004528d532316ca7befb880a8144aa62c53a4ebfe67bc9f4b2562"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "3ad6053f19aecead4051ec9f58962b369b3fc83235894d3bfd264100e9a8a068"
    sha256                               arm64_ventura:  "13a26c7f3fc705d6302a4bd8a69386f41eaa27e897371cf1b50a058d590919de"
    sha256                               arm64_monterey: "204b67a5b00981e705568c43e66578f29a3ff2b49932c128a21dd763708d3b41"
    sha256                               sonoma:         "5a005b7abe839cdebc2a289f014aeb92a777800dc431f6b30d0d306d513d35b3"
    sha256                               ventura:        "390f6e60b924cd8819de7ca2db2e9f0331505fd95d9505228cfd88866215ee93"
    sha256                               monterey:       "02bfc8cbe7e485fd10ab56c0b547721970f65acc65c7bcda978e95c6b571e194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a685ee3475cf5e81b3334cd0f49001252a2be113e029152de9454327d7d7057a"
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