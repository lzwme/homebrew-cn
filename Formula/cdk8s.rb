require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.75.tgz"
  sha256 "069b07fc93e4c097a74e46babac48bd60d60047ef751cca00d1717f42244ccfb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99a337edee1263e339c495fe10d2cdd3bc4c5f72dea32ba6590fc3628e85f37f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99a337edee1263e339c495fe10d2cdd3bc4c5f72dea32ba6590fc3628e85f37f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99a337edee1263e339c495fe10d2cdd3bc4c5f72dea32ba6590fc3628e85f37f"
    sha256 cellar: :any_skip_relocation, ventura:        "848de88cd4f2a9c91a3334c7603c1daa08668f90d302c489f0cabeb9913712b6"
    sha256 cellar: :any_skip_relocation, monterey:       "848de88cd4f2a9c91a3334c7603c1daa08668f90d302c489f0cabeb9913712b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "848de88cd4f2a9c91a3334c7603c1daa08668f90d302c489f0cabeb9913712b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a337edee1263e339c495fe10d2cdd3bc4c5f72dea32ba6590fc3628e85f37f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end