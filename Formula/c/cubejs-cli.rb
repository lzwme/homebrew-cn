require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.33.tgz"
  sha256 "ed6b3d273953ca48fb4a44cb31d07d4c490d3ca6c0c2dbd15cca0f7d7547b7fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8186f9c7f55ba1a4927ed52c110de7473735d1589303f38c2244b501ea7e1832"
    sha256 cellar: :any, arm64_ventura:  "8186f9c7f55ba1a4927ed52c110de7473735d1589303f38c2244b501ea7e1832"
    sha256 cellar: :any, arm64_monterey: "8186f9c7f55ba1a4927ed52c110de7473735d1589303f38c2244b501ea7e1832"
    sha256 cellar: :any, sonoma:         "4216a5bd98d81101240d6c8891c754b35e3cc6366dcf7bf8147ae9d0856d5691"
    sha256 cellar: :any, ventura:        "4216a5bd98d81101240d6c8891c754b35e3cc6366dcf7bf8147ae9d0856d5691"
    sha256 cellar: :any, monterey:       "4216a5bd98d81101240d6c8891c754b35e3cc6366dcf7bf8147ae9d0856d5691"
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