require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.28.tgz"
  sha256 "0ba8807ec7267291d3b3bcfbbc0ea70f22d02a6eedc72cf237d893559fdf6ac3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4855690c91b7a80d2aed2df5c2e9fb6e52a8df7fbaa57a11dece2f2500f86b70"
    sha256 cellar: :any, arm64_ventura:  "4855690c91b7a80d2aed2df5c2e9fb6e52a8df7fbaa57a11dece2f2500f86b70"
    sha256 cellar: :any, arm64_monterey: "4855690c91b7a80d2aed2df5c2e9fb6e52a8df7fbaa57a11dece2f2500f86b70"
    sha256 cellar: :any, sonoma:         "c01d7522bd81fa1c89a52eb16c63ab7f3d5084a87c1aace8ce95bd74abc45f3b"
    sha256 cellar: :any, ventura:        "c01d7522bd81fa1c89a52eb16c63ab7f3d5084a87c1aace8ce95bd74abc45f3b"
    sha256 cellar: :any, monterey:       "c01d7522bd81fa1c89a52eb16c63ab7f3d5084a87c1aace8ce95bd74abc45f3b"
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