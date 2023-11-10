require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.2.1.tgz"
  sha256 "667fa590047790d8b31b079a669f1a55ba1d8a9540408c53b0f87fce6b05582d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "3da282fea553185d01b769e326f4fa136f86e5ba64baf43449aae04389037b5d"
    sha256                               arm64_ventura:  "1f9abd2973f81e0422eb62cb8096db20e1ff80cc983f845270397039bdba02c6"
    sha256                               arm64_monterey: "259991a0f1bfa3d3f96b6bde5bff74a887eca35b16353d3fc40b83973a18e8f4"
    sha256                               sonoma:         "3b67605dc2af3fbab5313bee476a6acabc68b45ac95da4f6b077936dcb5b70b7"
    sha256                               ventura:        "afb774fc0d82136a9025edd9a87327736f75b81683764787a0d6f97b58ed024a"
    sha256                               monterey:       "968c2f8f350b0423719af250ba25eabda0f02298c85bf4dffe09a168a38eb4b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5485986909e242ec408286a6cc97c09048fb0bf64ef42433db6fd38a0b98fa5f"
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