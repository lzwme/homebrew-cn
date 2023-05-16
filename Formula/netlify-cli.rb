require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.1.0.tgz"
  sha256 "cd42c16f627dbb2bc66179b87737b41e99b34399f01cca0f92b6e70f54bec95c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "e1f1d0313815bafcd85afcdaa035d8f2e9c385d7721288e2dbb1fbb583ea8f0c"
    sha256                               arm64_monterey: "c02871af1ec118148b1cb922df246291675a300c2fd67027b50be3c9b7e13a42"
    sha256                               arm64_big_sur:  "2ad2cc67cda88cfdbfea771b2e8a135a543877ceff66fe6e6a9a3fec10f16894"
    sha256                               ventura:        "8852e3c5f6dcc82f880834902c4d4b4eaf246112dd5b1027a937dd631122987a"
    sha256                               monterey:       "ac795c018549d40e71f7b26bd87ba88c9ad88aa5b136b728a644018ba0dbd875"
    sha256                               big_sur:        "1923a488ea38c93a06ff4478f2bdd58c545edcc353afc10dd21e1ac0fd010645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4224c36e90681c46411d8b66a9d21638d7c86f9d1c76d612abc6e63fe92c4c4"
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