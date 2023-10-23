require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.9.1.tgz"
  sha256 "3c70903f7b8a2ec08c251ad5d3485813e15c26cd6e21f94a7eb5cf6b14be8ea6"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "fee127c575b572279aab18aeb34563a02673ae588144b0999e91a1a7f847b7fa"
    sha256                               arm64_ventura:  "4a4100732afb1cfc9c1beed17f3e6d7c201d684052925c065ccf542edf195a6b"
    sha256                               arm64_monterey: "e7bb1a0fd8eee22d1817be5a2d2424d604595abaea0d8af6e29ffb6d3c9388dd"
    sha256                               sonoma:         "8dc1618d5468bfdb1a2c581ef81433344e1899a924a5643b9159948c62d17d61"
    sha256                               ventura:        "0674bfc1ab78ebbb71e250dc66b02b0b790affc7f3b8dbfc385e709964f745c9"
    sha256                               monterey:       "a942d6f0b9edcce362cfb256741e62bbb73503f83f9db22024be609047cd0608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4857597c7eca795d9920c1b9c5ca1adac8c4f92d6cd42c2a1713b9ef82f5af4"
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