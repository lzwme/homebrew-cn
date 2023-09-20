require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.4.0.tgz"
  sha256 "b8149b87c0767a2727803e20fc6dbb68bb8de6e73d1a085671dc4862061d955e"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "d363e44295f097b0723d98a243e849ff2c0ba35a5b15ef4feaceeda34bf98d72"
    sha256                               arm64_monterey: "25627ae798103b1d98c064d7328f63e23abd746da1a4706a56c649db5a80d7e8"
    sha256                               arm64_big_sur:  "12be2788cdd10b680502fe0e42a8cc5a0a8f7d575b3cb6d4ae0ba354460d3618"
    sha256                               ventura:        "b2970ed4f1214edfc5f8bb14e078d59d3d9d34f4255328ea08c252bbd3b2b573"
    sha256                               monterey:       "e55c98f07847c307cbe73dbab89c7bf15911a0c02c0c9146fe40bc09ed022faf"
    sha256                               big_sur:        "445367c9254d9ab0b67c54b9c562e7b90d70e6abf401255ff8d1741e9c8a6d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd395b7557565641f520650cf8543cda2cf6a90b8237226abb277187a1f0a77e"
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