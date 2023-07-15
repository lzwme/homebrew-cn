require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.33.tgz"
  sha256 "2d79432e0b0b29af47c3b8962612c543ad156441702b4fad5b54fb595d1d8953"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d9729457be997babd3ce55657ea72d9bb142bb0462e445c25dccc6b9b9e19084"
    sha256 cellar: :any, arm64_monterey: "d9729457be997babd3ce55657ea72d9bb142bb0462e445c25dccc6b9b9e19084"
    sha256 cellar: :any, arm64_big_sur:  "d9729457be997babd3ce55657ea72d9bb142bb0462e445c25dccc6b9b9e19084"
    sha256 cellar: :any, ventura:        "5e6c869ba5f7b336246ab614bda2423939662443aa88641ef152187d75eb7930"
    sha256 cellar: :any, monterey:       "5e6c869ba5f7b336246ab614bda2423939662443aa88641ef152187d75eb7930"
    sha256 cellar: :any, big_sur:        "5e6c869ba5f7b336246ab614bda2423939662443aa88641ef152187d75eb7930"
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