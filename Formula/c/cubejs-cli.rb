require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.63.tgz"
  sha256 "492434fa7800d0bb532fa8d6c188b38dc3047c71aef082600ad11517b4353ba9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2dd7affda3672e90db27773e8faf1b2ac3d5f44e4efd65685320259b0e087ce1"
    sha256 cellar: :any, arm64_ventura:  "2dd7affda3672e90db27773e8faf1b2ac3d5f44e4efd65685320259b0e087ce1"
    sha256 cellar: :any, arm64_monterey: "2dd7affda3672e90db27773e8faf1b2ac3d5f44e4efd65685320259b0e087ce1"
    sha256 cellar: :any, sonoma:         "03b7100b497cd2183435c2d9b80426bd9ab62368cd8040a76ba8edd3b01dad24"
    sha256 cellar: :any, ventura:        "03b7100b497cd2183435c2d9b80426bd9ab62368cd8040a76ba8edd3b01dad24"
    sha256 cellar: :any, monterey:       "03b7100b497cd2183435c2d9b80426bd9ab62368cd8040a76ba8edd3b01dad24"
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