require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.11.0.tgz"
  sha256 "72f41b7a35bd9be74f8a02488933f72cd19c0cf15c0763ee84a90fda835ea433"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "9d43aeec2a2996e90b2f3e4b62fbdec600f293a98949746d29e46098f02aa9d3"
    sha256                               arm64_monterey: "14d378085c3a7c5fbfc857991b1312ce45fc81c72bb66b67583e433b2a0de146"
    sha256                               arm64_big_sur:  "c9b2b7e67ef08bc3e4f9b61fc4c44450384d8c3d33b3d323b5a408edd5bfb06b"
    sha256                               ventura:        "02ffec0b516bf08cff6d5e327cfc1921e81d845dd81292e1898d2264de32182b"
    sha256                               monterey:       "398763e6e35a111eed37d65700bd207490279095dc7d87a8d3d47e1bd8bb8e61"
    sha256                               big_sur:        "ab20182652944e4724b60398332997f01dab51297f55db19188b91045c0f95dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1fa0b476c5c0367f1c6db8a0684050e3c4471246f2e7915e3e313f5d589e060"
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