require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.87.0.tgz"
  sha256 "63f085ef2de3b34044b98f6fc2cdd11c0579699a29b0f460d03f25486122b218"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "820c24b5bafb590c14174f3d0672744de8020239d43c4f4a9344d622934f814f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820c24b5bafb590c14174f3d0672744de8020239d43c4f4a9344d622934f814f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "820c24b5bafb590c14174f3d0672744de8020239d43c4f4a9344d622934f814f"
    sha256 cellar: :any_skip_relocation, ventura:        "84bb80a8815dfea89beef7b7f44ded7005cc5e5660097338556f4babd059cc62"
    sha256 cellar: :any_skip_relocation, monterey:       "84bb80a8815dfea89beef7b7f44ded7005cc5e5660097338556f4babd059cc62"
    sha256 cellar: :any_skip_relocation, big_sur:        "84bb80a8815dfea89beef7b7f44ded7005cc5e5660097338556f4babd059cc62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "820c24b5bafb590c14174f3d0672744de8020239d43c4f4a9344d622934f814f"
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