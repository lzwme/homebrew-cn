require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.9.2.tgz"
  sha256 "11c593848d0d8b85f6f966ca9a64c8c56a2c247d16305f40cb0a43336647905e"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "4a7bbcd8d0bc95fb462eb93be8e9afeb17394c00666911f4b26d39c63c0b8ebc"
    sha256                               arm64_ventura:  "d26cea8de30f21ee62be97275d4fdf702983807ef39d69e5ec1d6a036c4cf377"
    sha256                               arm64_monterey: "75598d69aabec1efd835e04ad8dcdac8bb9c002fe3d428834cdea3e9f57a458e"
    sha256                               sonoma:         "9f4b99a1a353ae0ad39e18d892efb861109f181086479d7b0f8b592462067c65"
    sha256                               ventura:        "8379f6c6475818d2dce0fd6a39047f19bf7d4358d8cc5a6a78b8192fe2f2851b"
    sha256                               monterey:       "43b7053976bbe9c598ff48a0fee9927e9c3a669f726c0c007453cc63ab6b0881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cb5ff0abae0350a4f4e2890637e890eb424db8c75c7cf8f4f0542586136e9a0"
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