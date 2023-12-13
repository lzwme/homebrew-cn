require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.34.tgz"
  sha256 "14e91ac0e44d91c35dd6f326051d876e4f75a91f1ad9b8356edab82250156de9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "47a39bbc87fbbd7d7398e8393579e3861ac53e4884174d9b847ec143cf21d4c5"
    sha256 cellar: :any, arm64_ventura:  "47a39bbc87fbbd7d7398e8393579e3861ac53e4884174d9b847ec143cf21d4c5"
    sha256 cellar: :any, arm64_monterey: "47a39bbc87fbbd7d7398e8393579e3861ac53e4884174d9b847ec143cf21d4c5"
    sha256 cellar: :any, sonoma:         "5f5f40172ae998c7d01cfa7e1062d2737bee682fd408059de9d65e7f0cf65af8"
    sha256 cellar: :any, ventura:        "5f5f40172ae998c7d01cfa7e1062d2737bee682fd408059de9d65e7f0cf65af8"
    sha256 cellar: :any, monterey:       "5f5f40172ae998c7d01cfa7e1062d2737bee682fd408059de9d65e7f0cf65af8"
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