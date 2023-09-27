require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.62.tgz"
  sha256 "8d114bd0498cb902994cf2824c75b061c1b858134c391da9f0e2ce188fc19a5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1281aa5ff87774f002520ddb0931e38c3f66033616ce21c0c0d6c41fe0e29f8d"
    sha256 cellar: :any, arm64_ventura:  "1281aa5ff87774f002520ddb0931e38c3f66033616ce21c0c0d6c41fe0e29f8d"
    sha256 cellar: :any, arm64_monterey: "1281aa5ff87774f002520ddb0931e38c3f66033616ce21c0c0d6c41fe0e29f8d"
    sha256 cellar: :any, sonoma:         "0e23b9a643b1604e63c09a8f7944f25ad9ecd337b981b43e35c68b8057a459c0"
    sha256 cellar: :any, ventura:        "0e23b9a643b1604e63c09a8f7944f25ad9ecd337b981b43e35c68b8057a459c0"
    sha256 cellar: :any, monterey:       "0e23b9a643b1604e63c09a8f7944f25ad9ecd337b981b43e35c68b8057a459c0"
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