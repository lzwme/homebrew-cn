require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.10.tgz"
  sha256 "3fd266eabda30509cbc530d1d32bae911502c0a791ab67826769c64756c8c1c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e205d8c8f3ac38a8f7b5d19e34565f4f97c57c57dcb29ca422654146a9136ae4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e205d8c8f3ac38a8f7b5d19e34565f4f97c57c57dcb29ca422654146a9136ae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e205d8c8f3ac38a8f7b5d19e34565f4f97c57c57dcb29ca422654146a9136ae4"
    sha256 cellar: :any_skip_relocation, ventura:        "2f24162e8a291ca64e628e42430eb2e329b85bdc7584a22b2bc09ef86e638bcd"
    sha256 cellar: :any_skip_relocation, monterey:       "2f24162e8a291ca64e628e42430eb2e329b85bdc7584a22b2bc09ef86e638bcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f24162e8a291ca64e628e42430eb2e329b85bdc7584a22b2bc09ef86e638bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e205d8c8f3ac38a8f7b5d19e34565f4f97c57c57dcb29ca422654146a9136ae4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end