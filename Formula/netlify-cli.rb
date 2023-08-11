require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.0.1.tgz"
  sha256 "8acee9351524ee59ae3a41c73d1bed522ad5a1482453b50a2bd8926c0f237941"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "dcc61011190fa0d9c0a7b00f722c13a1dfa13b38faff3e4c49997bcc8a9de227"
    sha256                               arm64_monterey: "b0b3667d1e85a9c2ab64c097fa86b77e5fd86297f4c08a085669b2722ecc9315"
    sha256                               arm64_big_sur:  "12a28c882cdd919aa51f573dd7bec50d7428acb84c38ccd63caa32ddf22f940c"
    sha256                               ventura:        "e49cc15f065d619eed69a2e466ee6807e01849461b530b632fda7d737d09326a"
    sha256                               monterey:       "cdd8c44ebac0601f5238c89d59cb18aadcc83e202be6ae79c6c94a3606dbabe6"
    sha256                               big_sur:        "b181b78743948ad8d7d3251b689d7d1255d57cef35c8f22950fc43fcc447fd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673843050bd0a078ed4b5bca8e6a23a6207f6fdcdbaa9157937a86618b219ffc"
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