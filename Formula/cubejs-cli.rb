require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.41.tgz"
  sha256 "cf0a140d780cd658a04023c159083c84305c09914ba3f856777d6be23248a191"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "34ccc3b909464d0321737833e0161212f6f271736271706939a1ce3263afd4a1"
    sha256 cellar: :any, arm64_monterey: "34ccc3b909464d0321737833e0161212f6f271736271706939a1ce3263afd4a1"
    sha256 cellar: :any, arm64_big_sur:  "34ccc3b909464d0321737833e0161212f6f271736271706939a1ce3263afd4a1"
    sha256 cellar: :any, ventura:        "2e486033b564c553c4cc9fea2a69590382ca95eb7e706297252f6546c4d9c9ef"
    sha256 cellar: :any, monterey:       "2e486033b564c553c4cc9fea2a69590382ca95eb7e706297252f6546c4d9c9ef"
    sha256 cellar: :any, big_sur:        "2e486033b564c553c4cc9fea2a69590382ca95eb7e706297252f6546c4d9c9ef"
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