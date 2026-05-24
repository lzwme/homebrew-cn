class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.6.tgz"
  sha256 "445ad6a5a3bee63d43cc4901cb8600f1ef38486d462c81ce9f04e2a204079937"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c93cc2cf68544a5febfec4923feeb2147dd905ca11b75a7183bd7d438ec7ca00"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end