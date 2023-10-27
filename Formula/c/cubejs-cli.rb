require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.9.tgz"
  sha256 "5ccec7ca28cf9a064066873def00c79e8aa1d94cdc8bd8ef97d2b3af86dae620"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "56d5e224440ae4ccd0807bc67e63681deff4daa54dfe656fefb500071a7d7975"
    sha256 cellar: :any, arm64_ventura:  "56d5e224440ae4ccd0807bc67e63681deff4daa54dfe656fefb500071a7d7975"
    sha256 cellar: :any, arm64_monterey: "56d5e224440ae4ccd0807bc67e63681deff4daa54dfe656fefb500071a7d7975"
    sha256 cellar: :any, sonoma:         "302fb1004cb92f24ee7c6524a26b6cb1be768a90d24b5a070a0f9d967c76c5ac"
    sha256 cellar: :any, ventura:        "302fb1004cb92f24ee7c6524a26b6cb1be768a90d24b5a070a0f9d967c76c5ac"
    sha256 cellar: :any, monterey:       "302fb1004cb92f24ee7c6524a26b6cb1be768a90d24b5a070a0f9d967c76c5ac"
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