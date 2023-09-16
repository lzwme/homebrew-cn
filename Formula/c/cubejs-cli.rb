require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.57.tgz"
  sha256 "d7a7fd65af37414cffd25cea11770205a5ce2eb44fb9d77548d135ebc9e90ce8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f6f77bc47a9312974deb85ac48048b46f15eb34633280c5ff565b4b74bca638c"
    sha256 cellar: :any, arm64_monterey: "f6f77bc47a9312974deb85ac48048b46f15eb34633280c5ff565b4b74bca638c"
    sha256 cellar: :any, arm64_big_sur:  "f6f77bc47a9312974deb85ac48048b46f15eb34633280c5ff565b4b74bca638c"
    sha256 cellar: :any, ventura:        "7374a46798e1a952dab3c1c0c9080c1d53e00e6e124ab6d85b902b2a3b252d7b"
    sha256 cellar: :any, monterey:       "c5b0ca028fa805b8cfd5df533cc4601b05a745e56cea2b34102f5316c2bb9a65"
    sha256 cellar: :any, big_sur:        "c5b0ca028fa805b8cfd5df533cc4601b05a745e56cea2b34102f5316c2bb9a65"
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