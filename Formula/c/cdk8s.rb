require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.124.tgz"
  sha256 "15de1b76de6442ec9e1db3d54c9ca085c127220f7f1642114a39e4c99d77269d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bff774c27efad8d669ef430effcb0d0d6da6413d35fe8789d5e496cf1aca1c70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0183036f5d7124288dcd35932441c4a1a59d548a422bcc179c64229e3fdd40bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36dd74b11fda6c74291454867ef363fa25f129b243cfdc4803f85b0803999f75"
    sha256 cellar: :any_skip_relocation, sonoma:         "c010b4180a749d70c528c6bd33e043bdea40bffc2e4bbc5ee0929e2f2729a098"
    sha256 cellar: :any_skip_relocation, ventura:        "b2a23973df1f85e3a13e7292ce33c43a9aa804e2f5a83fac9af4f1bda0c4ca0a"
    sha256 cellar: :any_skip_relocation, monterey:       "fe40f3e356025506f3f702dbfcdf842158d7065d0386d4a23ea6f26d74ea30f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7fd6e12e2d9ae3ef07c5d381526173fd5ba853804153044221b9781d0363338"
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