require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.64.0.tgz"
  sha256 "93d9a377704ef7f24aff58707df80d07a59d39ba501d6fbef2d6d0dc6757b1c6"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2368d864c73414b60d356f07262f7c550a851e42ccc05ebf5d3aec25809fc21a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2368d864c73414b60d356f07262f7c550a851e42ccc05ebf5d3aec25809fc21a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2368d864c73414b60d356f07262f7c550a851e42ccc05ebf5d3aec25809fc21a"
    sha256 cellar: :any_skip_relocation, ventura:        "7f6b919a091aa7865756c4122a3118fab7718046a958689669908d5fda70740f"
    sha256 cellar: :any_skip_relocation, monterey:       "7f6b919a091aa7865756c4122a3118fab7718046a958689669908d5fda70740f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f6b919a091aa7865756c4122a3118fab7718046a958689669908d5fda70740f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2368d864c73414b60d356f07262f7c550a851e42ccc05ebf5d3aec25809fc21a"
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