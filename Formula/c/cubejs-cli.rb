require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.17.tgz"
  sha256 "81a0d6ca256bf4734d9e2d8e2a8b9000412be6797f09f4adfee3fbfaec9503ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "26aebcff3ec7d18a97c91a7f14ef9a91bceb5fa6f1043457ea79d0b6161cb6a1"
    sha256 cellar: :any, arm64_ventura:  "26aebcff3ec7d18a97c91a7f14ef9a91bceb5fa6f1043457ea79d0b6161cb6a1"
    sha256 cellar: :any, arm64_monterey: "26aebcff3ec7d18a97c91a7f14ef9a91bceb5fa6f1043457ea79d0b6161cb6a1"
    sha256 cellar: :any, sonoma:         "393c9629fc3b263abb1ee403e60f27ba67bc1c7792b8708290d737688da26e2c"
    sha256 cellar: :any, ventura:        "393c9629fc3b263abb1ee403e60f27ba67bc1c7792b8708290d737688da26e2c"
    sha256 cellar: :any, monterey:       "393c9629fc3b263abb1ee403e60f27ba67bc1c7792b8708290d737688da26e2c"
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