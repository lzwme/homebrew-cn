require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.1.1.tgz"
  sha256 "8f1bd69ca5d27bb6b765bc3986592fef8a678fc4dabaa27dbe97b1aa6092a7b5"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "6000e1903284bb006990e32af710f40f617003729e6c2114d04f0da656b92e36"
    sha256                               arm64_monterey: "5c87d31fa78495b6b861d433f91b6a54be21815b75c4a3ec24f07265d642347b"
    sha256                               arm64_big_sur:  "5ce42ea3d3d34f9921eeeab015e585d806cda3f69412ce04ed2026f40d8714a6"
    sha256                               ventura:        "c4128c087419afa454bf7bd680327d24ec106967cf406bf40fc8192dcfffa59a"
    sha256                               monterey:       "a1266bf940d67b0f8946608fcd4bc9c022d2f412eefedd57165b73e8196e2f66"
    sha256                               big_sur:        "9249f798e12f1ff5abddf15306db3f047ea4bba6766d38689ca45153b57bfacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "846d5f7076a9862c4a6539d046792d032292169e5ec9f4ea7e07e3bd23da800c"
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