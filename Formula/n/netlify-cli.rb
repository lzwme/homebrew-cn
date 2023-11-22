require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.6.0.tgz"
  sha256 "20b91c4b070ba7d3fad1511aeff4fa52bd959a11a7a1458b17c9ddf632463cf9"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "c0ece6495d9bbf28cc8aa85563539fd1f9ab53815b1cf80ad1582b2e6a184272"
    sha256                               arm64_ventura:  "a493645365ca8c2cbe0f1c4bcb722d66f14300879223c9c75b54a125150ce982"
    sha256                               arm64_monterey: "bb3d7422f3aa062790546caeca20c16fa3109b1f50d5fd6ba72f7a0226445a07"
    sha256                               sonoma:         "690a10bdb3980f9458a58d91ba5a3d226efe2280afeed4e48e87ca61cf778165"
    sha256                               ventura:        "8b7a71b204c3388903f9f9da5098ee1e4d1e6ed8ea81c9c8e7d9400a3843cd29"
    sha256                               monterey:       "5845a087b0835a0c15a6cbedf748f9e88c976479b45b0ce24e43225ad3fc482e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8f990db2193494b0af3bbe10fe33080cd662f3bd8123f5c2e8f03374280fa67"
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