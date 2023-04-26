require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-14.3.0.tgz"
  sha256 "5638526df2209b7f775ffe60e4abed88535d9c25f676ce350841197cc57bfc0f"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "ee9c5049ffd2659b1f1a8d1f52194ce90e59b4a40ca404e94b39d6d60a739a5e"
    sha256                               arm64_monterey: "857e00bd1caa03bfc6ad33c8946f28139c45c0cb6f6ebb3dcc5b4d9973a18ff6"
    sha256                               arm64_big_sur:  "da7aeef986655ab371603f68c2b025f89233343d2005ce9df0e117e4c7e46f6c"
    sha256                               ventura:        "036707ad0ddc501855a97faac1daf69d01a1a1371ec5cd29f971383f9d22bd2c"
    sha256                               monterey:       "e1a997aae05520349eab5ca7d892a65b5cd2a84bd41a1a5035abf74a0edee466"
    sha256                               big_sur:        "477668078f1da71d0f2c55fdc671d8ddbae002f4281edb78b85da3f13acbfda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61c6f06c605b2034cfb52c6240a26a3307cc35f08fda8310c3ed805bd0d85e4e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end