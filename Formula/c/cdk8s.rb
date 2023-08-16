require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.39.1.tgz"
  sha256 "05c600793eea36fd14f5f4b90985921d3df1c11930e7cf043caea3950d153eb1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "364ee5b65f6fe523acaf20b6dc285ba93929055f9569dbe1034c7f356529b7f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "364ee5b65f6fe523acaf20b6dc285ba93929055f9569dbe1034c7f356529b7f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "364ee5b65f6fe523acaf20b6dc285ba93929055f9569dbe1034c7f356529b7f5"
    sha256 cellar: :any_skip_relocation, ventura:        "27c64be1e5ee759cb50faaff1f21cb226fdf6cdf89e64d052e8a5e8232fe3f7d"
    sha256 cellar: :any_skip_relocation, monterey:       "27c64be1e5ee759cb50faaff1f21cb226fdf6cdf89e64d052e8a5e8232fe3f7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "27c64be1e5ee759cb50faaff1f21cb226fdf6cdf89e64d052e8a5e8232fe3f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364ee5b65f6fe523acaf20b6dc285ba93929055f9569dbe1034c7f356529b7f5"
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