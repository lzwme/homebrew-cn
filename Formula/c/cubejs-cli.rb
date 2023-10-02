require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.64.tgz"
  sha256 "44c1f9ce7bb4a5b9c5c8066451e2f382f94c6d5c971311601bd3ed3b4339d1c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "3a6b1982d4f7e7e436db25c0b889a90edb526b9e6a5308ead928cc5cc687211d"
    sha256 cellar: :any, arm64_ventura:  "3a6b1982d4f7e7e436db25c0b889a90edb526b9e6a5308ead928cc5cc687211d"
    sha256 cellar: :any, arm64_monterey: "3a6b1982d4f7e7e436db25c0b889a90edb526b9e6a5308ead928cc5cc687211d"
    sha256 cellar: :any, sonoma:         "4df25b54fa9c42a288951bad21eb729526cb89d7e07c57b0f79d510997e58acb"
    sha256 cellar: :any, ventura:        "4df25b54fa9c42a288951bad21eb729526cb89d7e07c57b0f79d510997e58acb"
    sha256 cellar: :any, monterey:       "4df25b54fa9c42a288951bad21eb729526cb89d7e07c57b0f79d510997e58acb"
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