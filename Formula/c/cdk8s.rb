class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.6.tgz"
  sha256 "0d004fec29bba09ef046862fd28e4b81b14a9ceac50c257d5f8adcfd2480ce9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc1c8ade1f54cfdf441d49464b5e8b3c1127499dcf072c937c69cf0ca01e7315"
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