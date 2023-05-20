require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.9.tgz"
  sha256 "a54d73d7607045672faf566f403b568f3d1041a0a3efc73940d82d284b404279"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20ec4088ca29129cbdc459dc5d494256903013ab0e3e050a123a047eff715013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ec4088ca29129cbdc459dc5d494256903013ab0e3e050a123a047eff715013"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20ec4088ca29129cbdc459dc5d494256903013ab0e3e050a123a047eff715013"
    sha256 cellar: :any_skip_relocation, ventura:        "9bf619e7f0e9246b1995323233da756de4105c9e7a6687840d8423193c33b316"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf619e7f0e9246b1995323233da756de4105c9e7a6687840d8423193c33b316"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bf619e7f0e9246b1995323233da756de4105c9e7a6687840d8423193c33b316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20ec4088ca29129cbdc459dc5d494256903013ab0e3e050a123a047eff715013"
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