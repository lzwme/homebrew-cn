require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.1.0.tgz"
  sha256 "cd0617890d6651a71aeb230e67fa38b724a8aeb9936501cda193b18b4e84ae2a"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "13ed61ef3a21f403da2611565567dd814b8e2376560fe6e9636a813eab1738b7"
    sha256                               arm64_ventura:  "ecc7b11542901c385ae2af95c49dabea75be5179eb04df38f328fb788cd4fd7c"
    sha256                               arm64_monterey: "7ef981a9d517993a58b9191d58e2e7b4da1f5bb1e81eaed140ed91b66c8bccca"
    sha256                               sonoma:         "c0a8ac7606597ec64f5bfe3ca8cb44e1ceea8c72ffee0b39fb7cefaecc094ad9"
    sha256                               ventura:        "4ee6910d26230861928bb72f6da5d9c967f7ea047527248496b2b72b56aba6bb"
    sha256                               monterey:       "2c8d1fbdfb47a0aee5f2a9604f7e1281ae4d2458685802920fd1b587c7cbaa66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6e6fc3c865eff18eb58afa2f22a2599c077ad2c1b8df3f2fe74b38fee83e794"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    if OS.linux?
      node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end