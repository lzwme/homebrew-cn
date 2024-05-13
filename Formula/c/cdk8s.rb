require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.117.tgz"
  sha256 "f33471868188f04dd698b1e4e38189b8e6edb89397610ed372f46950bd0209e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cfb28fdec5e6660879fe3efbc55b681abddb9ba93422ad30ffcac92e1158b04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e34300eba2e1e1350f2e2c8293fa6e217d83e52be76f7ca5f8ee3b76ce4b2c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57d70f7bd364875fc93f73d6397c45b1dd3a522865686b2c22308970a8a0ea36"
    sha256 cellar: :any_skip_relocation, sonoma:         "162bad2c5a6b81313ad440d41b0bb73899481e9ddc1321463dafcd9ec2fc0df7"
    sha256 cellar: :any_skip_relocation, ventura:        "9b3ada9f219c60f63f3d1901341ade2568327548171dbe78a20ee9e1f4f78841"
    sha256 cellar: :any_skip_relocation, monterey:       "1d497899a9ff4d92083e5368cfc7ae0732c24bc01a80c7afafd54d194b39f0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7323c166867788403217ae4241708d89535ddd2fd655fcaad44f3ed639762a94"
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