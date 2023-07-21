require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.37.tgz"
  sha256 "9b2338196709d50091ce8ee2202f0d1b755ab8b038552a84752837bd88148149"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b0a712cb1ec2eb7bc072cc55927679d4d0aca7d7f1e30654cf7f95a5e2a0aa4c"
    sha256 cellar: :any, arm64_monterey: "b0a712cb1ec2eb7bc072cc55927679d4d0aca7d7f1e30654cf7f95a5e2a0aa4c"
    sha256 cellar: :any, arm64_big_sur:  "b0a712cb1ec2eb7bc072cc55927679d4d0aca7d7f1e30654cf7f95a5e2a0aa4c"
    sha256 cellar: :any, ventura:        "4643d2d576166fe993da0458d02bde308e7a7984038c7d95bf5304a94b64d4c6"
    sha256 cellar: :any, monterey:       "4643d2d576166fe993da0458d02bde308e7a7984038c7d95bf5304a94b64d4c6"
    sha256 cellar: :any, big_sur:        "4643d2d576166fe993da0458d02bde308e7a7984038c7d95bf5304a94b64d4c6"
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