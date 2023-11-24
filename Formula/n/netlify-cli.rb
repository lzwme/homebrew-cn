require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.7.0.tgz"
  sha256 "3e47a3de024c629250ecb160eac433e7ce56aae32e421cfb1dce1f2cbf677980"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "68242ecd079d7a3d68d7c8bd906fc09c0bd7fd3d4e9ef579d7afee627cd2af2c"
    sha256                               arm64_ventura:  "a63e294ce6c1306a75550e6679934af56dbab6dbc07c6824ba57a6691c28cd55"
    sha256                               arm64_monterey: "c2ca9d8023b3b776197ab6ce65da92ef8cdbad510d3dd0e6d550fceb8d9e6b04"
    sha256                               sonoma:         "da6149097e0672185fd56ddead037827650f941d0785130aa7c41d6c5b8da7a7"
    sha256                               ventura:        "da59cdceafbf51ecc8d4e8965228560802cf5cca1a5c5143371895812fe95745"
    sha256                               monterey:       "7f20210590904eeb8e351e385db47a3dd2346c0fcf69a93d7c332891aff848e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d251808fea1e6e252808e54fecd2b22393f8ce82c531f9066acc7414f054fd2"
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