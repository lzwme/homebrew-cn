require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.10.0.tgz"
  sha256 "58d62043466ca0629a97c872189fd4d7dba44b7fb5590ef8cd8bd7b3abfd1eef"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "69ca6ed4debec855c6ba25f4527b3675072e685984105c8defd121749e8a2695"
    sha256                               arm64_ventura:  "012c5d8011beaeb4f1f202c1f04d93da6e23db9356768d504f9177f8fdd532ef"
    sha256                               arm64_monterey: "b0f47725317525cffa98648fe53409f86a6a183e821fa9c5dc74921847c9ad49"
    sha256                               sonoma:         "7b996f0f6e87d49b7720fe030b65bd8dd63e2428346b6efdd7d4922b59a252c5"
    sha256                               ventura:        "85c3e210ea1382842b8c2435d78a10bbc19ae9dd1dc2f131eb49f79136605131"
    sha256                               monterey:       "36e2d5754b499332ba852b0d6b0eab20f9935efa111746e6b8794739be0eb033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b82d83392723f42ac83954b8c44f3850c79df0b9942e2c3f9fec322e43ef742"
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