require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.3.5.tgz"
  sha256 "999341bac8bd03bf2a27855116b870590faa9d2508425bbb316205d09e1f6c76"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3420355f2c4b2794f5f0302d24e9bb8eb6ef180936c2c6c9eaea5239a75e4fb"
    sha256 cellar: :any,                 arm64_ventura:  "a3420355f2c4b2794f5f0302d24e9bb8eb6ef180936c2c6c9eaea5239a75e4fb"
    sha256 cellar: :any,                 arm64_monterey: "a3420355f2c4b2794f5f0302d24e9bb8eb6ef180936c2c6c9eaea5239a75e4fb"
    sha256 cellar: :any,                 sonoma:         "7f867e3bfc0d1119a3b39e3a6a03e7214f4218c89609c0d04cc0196fe2d153fa"
    sha256 cellar: :any,                 ventura:        "7f867e3bfc0d1119a3b39e3a6a03e7214f4218c89609c0d04cc0196fe2d153fa"
    sha256 cellar: :any,                 monterey:       "7f867e3bfc0d1119a3b39e3a6a03e7214f4218c89609c0d04cc0196fe2d153fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a534bd3322649959cda696743cdb842e11dc15b57fa09cc42baf2eaec76ad47"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end