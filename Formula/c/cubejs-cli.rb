require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.52.tgz"
  sha256 "d79e84706540d4958ed1705ae2711bd28d9b0ca28ac7f6bce1ecc2dd1cdc5244"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "403e7a3a2a77a498d085269f49c96c63516d31f52c07f94f023b0054ee9d25f4"
    sha256 cellar: :any,                 arm64_monterey: "403e7a3a2a77a498d085269f49c96c63516d31f52c07f94f023b0054ee9d25f4"
    sha256 cellar: :any,                 arm64_big_sur:  "403e7a3a2a77a498d085269f49c96c63516d31f52c07f94f023b0054ee9d25f4"
    sha256 cellar: :any,                 ventura:        "2245198d9de30466a4b70e4111a661e7747719a22e96e2436d6204d1239d2e81"
    sha256 cellar: :any_skip_relocation, monterey:       "8d209c0d2e92830ad87697390f126f5192c3bf522650e8a28e932af1e6a7df27"
    sha256 cellar: :any,                 big_sur:        "2245198d9de30466a4b70e4111a661e7747719a22e96e2436d6204d1239d2e81"
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