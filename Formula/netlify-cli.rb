require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-13.2.2.tgz"
  sha256 "d2833a5548bec0581cffa02094097d89f9a9e6a46230585a21174393aa54a2f1"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "f583bd94d1e286022919b359b3d72f5a4216f2860e784c72407bda8ab75b5b3d"
    sha256                               arm64_monterey: "4a1a98db30ce024c66607efdcbca21329e0ae96672c971646330c387600ce0e3"
    sha256                               arm64_big_sur:  "06d2046e6deb2ee1cc9ac01693bf1ad1e881903f44df40f39f0147adba7ac4cc"
    sha256                               ventura:        "77ad5bc31ee7033e60d6cb020b42ca1937c71f9694db3d921e7e9293be535fb5"
    sha256                               monterey:       "8c97d2a56d5de6d4c83191a8a3a77648e8ecdc9d46fe6f09e205e502092ce76d"
    sha256                               big_sur:        "5789b19c61bf0dbe872e7a59abee0439974f06b16e7156d3328b9172d99b5ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "305475c85916ef514f43699fb278e0078f298f669df11ed30ab8dd326dead148"
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