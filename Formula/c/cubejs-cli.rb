require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.23.tgz"
  sha256 "5bd3fb079b069625214097b296e4508ef39a1ce869cc226e7defb9eb1892eaed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b144b903f62735a461156094860ed384f1959010489d652496928b2605e6dae"
    sha256 cellar: :any,                 arm64_ventura:  "4b144b903f62735a461156094860ed384f1959010489d652496928b2605e6dae"
    sha256 cellar: :any,                 arm64_monterey: "4b144b903f62735a461156094860ed384f1959010489d652496928b2605e6dae"
    sha256 cellar: :any,                 sonoma:         "2d655a01aac68255a4dfcf4dca8446c66547b9a2bc99387e19b77a1c2f83d38f"
    sha256 cellar: :any,                 ventura:        "2d655a01aac68255a4dfcf4dca8446c66547b9a2bc99387e19b77a1c2f83d38f"
    sha256 cellar: :any,                 monterey:       "2d655a01aac68255a4dfcf4dca8446c66547b9a2bc99387e19b77a1c2f83d38f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e893c64141207a3fefcc43f6d14b9402a3a02177a7bfc217d4ed6dde0891b981"
  end

  depends_on "node"
  uses_from_macos "zlib"

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