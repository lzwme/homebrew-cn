require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.30.1.tgz"
  sha256 "c7c2ecf416b47d6fba6eacf2912bcc618a1bfb2b66b7065198227de9ee737679"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0e14c1c8f467336e79c59726d795dd16ad7206fad2c9f21722f320afdae2229"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0e14c1c8f467336e79c59726d795dd16ad7206fad2c9f21722f320afdae2229"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0e14c1c8f467336e79c59726d795dd16ad7206fad2c9f21722f320afdae2229"
    sha256 cellar: :any_skip_relocation, ventura:        "f9233da3b21517587eaa39ba9fa8526590fa96716b2978ac1926e6646815ba51"
    sha256 cellar: :any_skip_relocation, monterey:       "f9233da3b21517587eaa39ba9fa8526590fa96716b2978ac1926e6646815ba51"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9233da3b21517587eaa39ba9fa8526590fa96716b2978ac1926e6646815ba51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0e14c1c8f467336e79c59726d795dd16ad7206fad2c9f21722f320afdae2229"
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