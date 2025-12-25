class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.14.tgz"
  sha256 "3129c5c72b62137ee43bcf875b728fb86545658a17e005030e1026725ae5a9eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1267f2331a0a9eb2b02e7c038d4493ea0631dd6c05c8feb98fad8e6c7595fb5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end