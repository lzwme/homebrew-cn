require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.58.tgz"
  sha256 "148a6e75a989288a4016d6bda019957b1462e932e5c4b530d59668f80140fb1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d9e91a42a95c9d36b0dd5d51cbf5062cfbd6b2ff6666d72b578a7e1a1671cd96"
    sha256 cellar: :any, arm64_monterey: "d9e91a42a95c9d36b0dd5d51cbf5062cfbd6b2ff6666d72b578a7e1a1671cd96"
    sha256 cellar: :any, arm64_big_sur:  "d9e91a42a95c9d36b0dd5d51cbf5062cfbd6b2ff6666d72b578a7e1a1671cd96"
    sha256 cellar: :any, ventura:        "c6d88cb2c05e2faae5cd8d9f2ababc1f56a2f4a1379e29517e39f083b3ae28c4"
    sha256 cellar: :any, monterey:       "c6d88cb2c05e2faae5cd8d9f2ababc1f56a2f4a1379e29517e39f083b3ae28c4"
    sha256 cellar: :any, big_sur:        "c6d88cb2c05e2faae5cd8d9f2ababc1f56a2f4a1379e29517e39f083b3ae28c4"
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