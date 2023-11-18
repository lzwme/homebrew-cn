require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.5.1.tgz"
  sha256 "aeaaf12ba1f4c072bc0bda7f439ed3eb0755d5fc45190fd5e84ae8a501d984b1"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "204b2a68c82d0c3556ba13a7e0c0c1c873f40733c4c71fcfdfe8ec69983299e7"
    sha256                               arm64_ventura:  "fb437a9571b1e8594e437a63d96999ef2ce1bf7c4ee8f78618cc1b33a9341f0c"
    sha256                               arm64_monterey: "d5771199b6dd856e0f04a0918059447ab6ff3d06af8e4ad99a91c1638884aa2e"
    sha256                               sonoma:         "4eae7a990b61c0fedd9522dea7beb808b1d79e367314920e6bd6853680637dd7"
    sha256                               ventura:        "c309f3f1b3f4b157711c23c4d4b7842cbd6b0d66b3e3df9343a514d1d6cc6781"
    sha256                               monterey:       "18d72a59a5039b0ffc6b741464958df1c600019856970ef2492781c307d9e966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3851754b55fe951652039ba105e8ecc4c81c1b7656bd1bc1fbead739ae95a4ae"
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