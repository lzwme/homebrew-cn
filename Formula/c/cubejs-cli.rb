require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.48.tgz"
  sha256 "d963a11f8c862133441a4d8be5fe791224e35d86786b745a67db67cc3f588ea7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "850936538e1c727059588c746f331cab83bf6270b8862875380c85d5f1f48b39"
    sha256 cellar: :any, arm64_monterey: "850936538e1c727059588c746f331cab83bf6270b8862875380c85d5f1f48b39"
    sha256 cellar: :any, arm64_big_sur:  "850936538e1c727059588c746f331cab83bf6270b8862875380c85d5f1f48b39"
    sha256 cellar: :any, ventura:        "dcc1df05b1386f85c08414c6e7c449a2aec2a43afdb7c064d70929bf79e859e8"
    sha256 cellar: :any, monterey:       "dcc1df05b1386f85c08414c6e7c449a2aec2a43afdb7c064d70929bf79e859e8"
    sha256 cellar: :any, big_sur:        "dcc1df05b1386f85c08414c6e7c449a2aec2a43afdb7c064d70929bf79e859e8"
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