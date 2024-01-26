require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.48.tgz"
  sha256 "1bffcc4cb47ad2ac6c19254e44e1b0d3b079b3d78a6b944fd3c3c424916e64b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9f7d4db552ee7c13259fc30754fb48435b4cd4298e65b1340e96678635bb33a4"
    sha256 cellar: :any, arm64_ventura:  "9f7d4db552ee7c13259fc30754fb48435b4cd4298e65b1340e96678635bb33a4"
    sha256 cellar: :any, arm64_monterey: "9f7d4db552ee7c13259fc30754fb48435b4cd4298e65b1340e96678635bb33a4"
    sha256 cellar: :any, sonoma:         "ba1e38f5fe0433855a1dd5fc583ede94b4c287c30bfbbf8dfb9846db3cb9e5aa"
    sha256 cellar: :any, ventura:        "ba1e38f5fe0433855a1dd5fc583ede94b4c287c30bfbbf8dfb9846db3cb9e5aa"
    sha256 cellar: :any, monterey:       "ba1e38f5fe0433855a1dd5fc583ede94b4c287c30bfbbf8dfb9846db3cb9e5aa"
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