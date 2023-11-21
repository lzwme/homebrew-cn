require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.5.3.tgz"
  sha256 "d33f1f4cd29cbebd1f9bb8c5c7f9d383d178bc9c6248ec1b3b1a1debe9bbdffe"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "9a135c8cc13e148fc0170ba87f6ebb839613ba5a5ce430477355472fbce35926"
    sha256                               arm64_ventura:  "751610eb40008208d17e385de7a8faf8983171eb51f6564e0c7ce69a3ac50d5a"
    sha256                               arm64_monterey: "1c98cd41d70d969957544b8fb411bd28841b1683393ea884b24aa9b87fe1d627"
    sha256                               sonoma:         "9e903e84d42e774a3b6e1c06a213048e49898e61d84acaeee97d81e32b095755"
    sha256                               ventura:        "d123e1566103b655728b3df14cc738557fb3f3f8179c15516de616a426932953"
    sha256                               monterey:       "3fd164142de203701b0bcf3e7bee69c3f9aa8d764d642aa3f6a3ec252cbd404d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3153d81649ebbd49d136aea295320e2e4a7a5098bda780efebd236a5402d27"
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