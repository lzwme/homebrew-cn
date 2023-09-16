require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.88.0.tgz"
  sha256 "eea76ae8f15001d9e39a48ea5f0369ac4d227a18ed32f6fa2eb6a2b0b657495f"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "475017ee7bdca13e9582a453fc30961880bc64520e74d0934ef65293ebb11988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "475017ee7bdca13e9582a453fc30961880bc64520e74d0934ef65293ebb11988"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "475017ee7bdca13e9582a453fc30961880bc64520e74d0934ef65293ebb11988"
    sha256 cellar: :any_skip_relocation, ventura:        "974fec3fd115334152c6f2d8386c644d79e4e3951eff3fd5d6d32d5405cf5504"
    sha256 cellar: :any_skip_relocation, monterey:       "974fec3fd115334152c6f2d8386c644d79e4e3951eff3fd5d6d32d5405cf5504"
    sha256 cellar: :any_skip_relocation, big_sur:        "974fec3fd115334152c6f2d8386c644d79e4e3951eff3fd5d6d32d5405cf5504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "475017ee7bdca13e9582a453fc30961880bc64520e74d0934ef65293ebb11988"
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