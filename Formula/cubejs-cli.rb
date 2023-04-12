require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.24.tgz"
  sha256 "53c172bf2e09f9a98080626b4f526a2c86c4cedafae3c9e551c9dc45df3a13f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bf97a38fca9e4020ad72e80bd967209a34463f49d6040f0e92e093661e1f615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bf97a38fca9e4020ad72e80bd967209a34463f49d6040f0e92e093661e1f615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bf97a38fca9e4020ad72e80bd967209a34463f49d6040f0e92e093661e1f615"
    sha256 cellar: :any_skip_relocation, ventura:        "cadeaff987d3e7da2c66b7044ba404499d503e78ad562b4747c0092127b44e33"
    sha256 cellar: :any_skip_relocation, monterey:       "cadeaff987d3e7da2c66b7044ba404499d503e78ad562b4747c0092127b44e33"
    sha256 cellar: :any_skip_relocation, big_sur:        "cadeaff987d3e7da2c66b7044ba404499d503e78ad562b4747c0092127b44e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bf97a38fca9e4020ad72e80bd967209a34463f49d6040f0e92e093661e1f615"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end