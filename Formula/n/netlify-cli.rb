require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.9.3.tgz"
  sha256 "5ebb76572f82168ea431b4afe2b8fb32f79fea302da0785e59dfdbe3608f5f4f"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "2d8c7a13fe00dd87b3a4db7afcd0617802bdfc61a95104225cc9647f9388a554"
    sha256                               arm64_ventura:  "5c521b3a7e73a288581a72e8ea03ee2f653d2808c92418ee0c229f00150d0102"
    sha256                               arm64_monterey: "d688007c40fba166e70ff24a4832cbb97f0cb67dd8acf5361a9a42dc1ca1ea58"
    sha256                               sonoma:         "3c31bd51c9d8e464e1d545b445d0e04488f8c7198c416bb3bd7b13d4df6f1016"
    sha256                               ventura:        "9a5537d85f585c6db3969cce39537a95230fc2a6a4eb1e3564f209fa004d56fb"
    sha256                               monterey:       "9795276181f4e6be73059696bdc8bb38936c42853233dcf9b21c64fdc035f375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00c200d680841184951448afe00da25fef4879ffb641d45d9c1998bd5a27503"
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