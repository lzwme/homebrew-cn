require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.2.0.tgz"
  sha256 "238b601d73295244023950a9d66359d65cdb60846e72d4c6e470b5e250c04b2e"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "8099e465620abc612861feee82dcdbdf82d38f2077c493dfbec54322615f8f02"
    sha256                               arm64_ventura:  "dba738ee9719f56a9361f8c9b074d8d34110e795ed75bb15128bc9f3d6a4d3f7"
    sha256                               arm64_monterey: "4dbfaa6adbd2b7e51b81fc4e259585b0e6596a07051b3e40c2f3fc5407f1451f"
    sha256                               sonoma:         "1e1c69bcefe08b85b3ea17f7dddffc46a9fb917af504ca9dd21a6406a463fc6d"
    sha256                               ventura:        "1b1c027b3865b0b4f91294615a0e8643fd0a7d182ceef5e3fd2fbebf70e64510"
    sha256                               monterey:       "6750b88e27304cdfcaaca193040ccf8a198d3ae3f8a6ecf8d7c113488d99944a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d77224c055858592d90e3e9d560f616e25c548746fe825d8d5c714c660d20663"
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