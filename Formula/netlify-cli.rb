require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.0.2.tgz"
  sha256 "0fd76f5079aa1ef25c26a0c8d7b8637b4aefb15de83be481bb7a00d0377084a2"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "9c0c449ad2c53e0126f1081022336533b9e998006e50b7f7b7441d25937af208"
    sha256                               arm64_monterey: "e52707d9e00494dadead8565c899312ad8510d22cddac9836c3b585f29fa7c74"
    sha256                               arm64_big_sur:  "819857d0ba0c6c7945b43425b58d92dc1be8b80e1318c3b5acd2264e9731781b"
    sha256                               ventura:        "f4b0eb51d492699d123dec36f44968bb654745c3d70175cc2ffb3e220abd2ec3"
    sha256                               monterey:       "6b88a9ef2b5bd2f09724a7610dff2257fc04065bac0cae7753e361ca4994ae52"
    sha256                               big_sur:        "ab85b8da1741a54f0036899e6e32b0e13fd5ba0c6546115bf0cf1a4c5b7eef20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89e8348d58db0940d73b46f4a46410e3ca120f8a2fb86f407f89f3860e99a485"
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