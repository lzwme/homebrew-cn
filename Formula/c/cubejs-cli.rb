require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.14.tgz"
  sha256 "5b87b5665f6f735c507f4c25692b3cc3955f0069a48cd524539e10d5dcb79e27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "74f5697ee9d705af50ea31efc14cd6a195311356e801e67a1c817887da2cbba0"
    sha256 cellar: :any, arm64_ventura:  "74f5697ee9d705af50ea31efc14cd6a195311356e801e67a1c817887da2cbba0"
    sha256 cellar: :any, arm64_monterey: "74f5697ee9d705af50ea31efc14cd6a195311356e801e67a1c817887da2cbba0"
    sha256 cellar: :any, sonoma:         "41a8bdc6895fe24775b13a7b315edcd59ac0f0b4d4da1e3181037fbcf81abaf5"
    sha256 cellar: :any, ventura:        "41a8bdc6895fe24775b13a7b315edcd59ac0f0b4d4da1e3181037fbcf81abaf5"
    sha256 cellar: :any, monterey:       "41a8bdc6895fe24775b13a7b315edcd59ac0f0b4d4da1e3181037fbcf81abaf5"
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