require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.53.tgz"
  sha256 "5cc73c2fb08f16754027a9a6b87b6c667cf5fad1cf4aa4e04f8b26327022b933"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "670c0664a81fd08b552811cdd8eaaf4a7de9b739ef84be6f106ee56fbad3d9b9"
    sha256 cellar: :any, arm64_monterey: "670c0664a81fd08b552811cdd8eaaf4a7de9b739ef84be6f106ee56fbad3d9b9"
    sha256 cellar: :any, arm64_big_sur:  "670c0664a81fd08b552811cdd8eaaf4a7de9b739ef84be6f106ee56fbad3d9b9"
    sha256 cellar: :any, ventura:        "6fcac0346ec720821a9a11910c6524e61123544e1ffb46b7cef76afecd9839c7"
    sha256 cellar: :any, monterey:       "6fcac0346ec720821a9a11910c6524e61123544e1ffb46b7cef76afecd9839c7"
    sha256 cellar: :any, big_sur:        "6fcac0346ec720821a9a11910c6524e61123544e1ffb46b7cef76afecd9839c7"
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