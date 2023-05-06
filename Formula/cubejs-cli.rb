require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.3.tgz"
  sha256 "caee746db546b5304f5947f004fb2731d0e09d506bad7444a43f2690e3464335"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc3a66d18824d2be3d9c82b81afd9222e8b36907d88da292f9247f728d8c120c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc3a66d18824d2be3d9c82b81afd9222e8b36907d88da292f9247f728d8c120c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc3a66d18824d2be3d9c82b81afd9222e8b36907d88da292f9247f728d8c120c"
    sha256 cellar: :any_skip_relocation, ventura:        "fe698cdfabc69cb6a00f825caa125370b9a7b6e7fdd0c743e6f8cac5315bdf54"
    sha256 cellar: :any_skip_relocation, monterey:       "fe698cdfabc69cb6a00f825caa125370b9a7b6e7fdd0c743e6f8cac5315bdf54"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe698cdfabc69cb6a00f825caa125370b9a7b6e7fdd0c743e6f8cac5315bdf54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3a66d18824d2be3d9c82b81afd9222e8b36907d88da292f9247f728d8c120c"
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