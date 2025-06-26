class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.26.tgz"
  sha256 "e331f206a63f88099e27296f352bc222612575779ad83a807e68c85e51c92207"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e0a1ff3f659bb319023a7aa770bea16077917abad56d14384d431eeb6438160"
    sha256 cellar: :any,                 arm64_sonoma:  "1e0a1ff3f659bb319023a7aa770bea16077917abad56d14384d431eeb6438160"
    sha256 cellar: :any,                 arm64_ventura: "1e0a1ff3f659bb319023a7aa770bea16077917abad56d14384d431eeb6438160"
    sha256 cellar: :any,                 sonoma:        "a439fe2447de36fefb2e6cfd24c4e50c8208af8acf4baac0831ada3b887ce765"
    sha256 cellar: :any,                 ventura:       "a439fe2447de36fefb2e6cfd24c4e50c8208af8acf4baac0831ada3b887ce765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "165c7c766317cbdbc6f1fdd3869e2cf6fe5523c4c0ffd94baf2053ba1ba6dd8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d6cf2f7f49dc311c085e13b9e6799c27580f5393b9e823df9469736551791ff"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end