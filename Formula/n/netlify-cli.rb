require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.0.1.tgz"
  sha256 "8072a40642ec8d89cf95d285fc4cf9fa979ea3e5c2ad13437f8cd19664f1898d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "a80eb476b9cad61f34db94c13b36f794d476c4468f7159ed78898ff9fd07dc91"
    sha256                               arm64_ventura:  "a7a58c8b3dbb71121ff408cb9fdf37d44af74587e989389ff8711c45dd68c53f"
    sha256                               arm64_monterey: "4f69cb3b90af0fdc7ccce98f6914be9b13188bb863025e891cec71280ab18fe3"
    sha256                               sonoma:         "63303d25ccaa52065fc81e69c9b4c3a17960e5ce94d7fb43b5fd8ad712c86b82"
    sha256                               ventura:        "4b02b1c8a5aeaf96049932cdcff179d2737d1fd871e233bbda76e688938bc7f9"
    sha256                               monterey:       "d6a551dc000897dcaad914bddb0de2cabb1a398252c352f7e266ed0d08c82dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71ac80d792d7f73a89a10f3c77cb93fdb117bce6ad7feb3dafec86ba596d973"
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