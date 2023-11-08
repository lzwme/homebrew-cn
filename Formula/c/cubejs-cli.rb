require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.16.tgz"
  sha256 "75a9c39a1c5550e0a50fbfd2bf1fe195f091367947dc1501f74d7af3184a6da4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e4e1759ea5b31dea68d3e86763834966652b195b8ee3bf03ebbb52a2e7c6c05d"
    sha256 cellar: :any, arm64_ventura:  "e4e1759ea5b31dea68d3e86763834966652b195b8ee3bf03ebbb52a2e7c6c05d"
    sha256 cellar: :any, arm64_monterey: "e4e1759ea5b31dea68d3e86763834966652b195b8ee3bf03ebbb52a2e7c6c05d"
    sha256 cellar: :any, sonoma:         "7d1857beb258c3080f4ed02aba78dddefcc80453d0a89839f9d3d378390e7631"
    sha256 cellar: :any, ventura:        "7d1857beb258c3080f4ed02aba78dddefcc80453d0a89839f9d3d378390e7631"
    sha256 cellar: :any, monterey:       "7d1857beb258c3080f4ed02aba78dddefcc80453d0a89839f9d3d378390e7631"
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