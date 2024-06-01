require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.134.tgz"
  sha256 "70bdaf3248c79ce098f81104d43bc9c66b5de115d77f7a750cac239757e85f13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "593175c10ab46769bea5c3b200ccf4a1225323d985cbb1a7bf0ef798e1885dee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "593175c10ab46769bea5c3b200ccf4a1225323d985cbb1a7bf0ef798e1885dee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "593175c10ab46769bea5c3b200ccf4a1225323d985cbb1a7bf0ef798e1885dee"
    sha256 cellar: :any_skip_relocation, sonoma:         "90ec23b52c19a42c32a2b9813e9661cc1587c8e14768cb0232929dde221e4bc4"
    sha256 cellar: :any_skip_relocation, ventura:        "90ec23b52c19a42c32a2b9813e9661cc1587c8e14768cb0232929dde221e4bc4"
    sha256 cellar: :any_skip_relocation, monterey:       "90ec23b52c19a42c32a2b9813e9661cc1587c8e14768cb0232929dde221e4bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac422e34c752f6bae358fa0a0a4fee8eb9ce8f291ce7ea81de6a537ea9699a79"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end