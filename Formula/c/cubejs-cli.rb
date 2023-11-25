require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.25.tgz"
  sha256 "01fb2c7ac5f5c3b18e369f29859c5cbb42e0663641943ac0f171689b49ae079a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2dae9c12634ec52fbb0919935a64110f6ce3578e66a5e4dec74bd4497790a201"
    sha256 cellar: :any, arm64_ventura:  "2dae9c12634ec52fbb0919935a64110f6ce3578e66a5e4dec74bd4497790a201"
    sha256 cellar: :any, arm64_monterey: "2dae9c12634ec52fbb0919935a64110f6ce3578e66a5e4dec74bd4497790a201"
    sha256 cellar: :any, sonoma:         "6564063bc288530e762a5d616dcc5d038c2b150841bfa01194b3aee9331da506"
    sha256 cellar: :any, ventura:        "6564063bc288530e762a5d616dcc5d038c2b150841bfa01194b3aee9331da506"
    sha256 cellar: :any, monterey:       "6564063bc288530e762a5d616dcc5d038c2b150841bfa01194b3aee9331da506"
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