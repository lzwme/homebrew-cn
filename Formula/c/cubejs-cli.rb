require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.26.tgz"
  sha256 "6081db6141c6f7602e28ec06d3caca893be52afd855dc268370778a4c61ffa12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d60e887cd1c5f0b241c9365172e77bd847d1ef40007093b1424b7ea3b7a01270"
    sha256 cellar: :any, arm64_ventura:  "d60e887cd1c5f0b241c9365172e77bd847d1ef40007093b1424b7ea3b7a01270"
    sha256 cellar: :any, arm64_monterey: "d60e887cd1c5f0b241c9365172e77bd847d1ef40007093b1424b7ea3b7a01270"
    sha256 cellar: :any, sonoma:         "f0ba6063e42c8f28b1b28d1b542d69a583ef4fdab5d2d08f9400e5907b93350e"
    sha256 cellar: :any, ventura:        "f0ba6063e42c8f28b1b28d1b542d69a583ef4fdab5d2d08f9400e5907b93350e"
    sha256 cellar: :any, monterey:       "f0ba6063e42c8f28b1b28d1b542d69a583ef4fdab5d2d08f9400e5907b93350e"
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