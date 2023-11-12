require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.19.tgz"
  sha256 "4762d058c1501a410461fb34b059edb6b7ef24b5a18b3d5f813d3528189bcdaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5d1677fdb5273835eb6d97b0c07f90bb0842ba25b84e1ea764d6a9837d218bf8"
    sha256 cellar: :any, arm64_ventura:  "5d1677fdb5273835eb6d97b0c07f90bb0842ba25b84e1ea764d6a9837d218bf8"
    sha256 cellar: :any, arm64_monterey: "5d1677fdb5273835eb6d97b0c07f90bb0842ba25b84e1ea764d6a9837d218bf8"
    sha256 cellar: :any, sonoma:         "29925f1f0af8bd17242750501a3eff2cadccfef564ba109a1580ab1683585498"
    sha256 cellar: :any, ventura:        "29925f1f0af8bd17242750501a3eff2cadccfef564ba109a1580ab1683585498"
    sha256 cellar: :any, monterey:       "29925f1f0af8bd17242750501a3eff2cadccfef564ba109a1580ab1683585498"
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