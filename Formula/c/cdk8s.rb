require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.141.0.tgz"
  sha256 "0fa2d9d228f16658bd905be150100872da386619189a14459fb5e68ad577bd1e"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f180b5080e9d8fc17f5327f6c8b298405a849127d637b55dc8a75bfd97c36d6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f180b5080e9d8fc17f5327f6c8b298405a849127d637b55dc8a75bfd97c36d6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f180b5080e9d8fc17f5327f6c8b298405a849127d637b55dc8a75bfd97c36d6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b3cb95f2e2d779317d6daecafd1957b8cf19c0b2128b095fe0682efff7291f7"
    sha256 cellar: :any_skip_relocation, ventura:        "6b3cb95f2e2d779317d6daecafd1957b8cf19c0b2128b095fe0682efff7291f7"
    sha256 cellar: :any_skip_relocation, monterey:       "6b3cb95f2e2d779317d6daecafd1957b8cf19c0b2128b095fe0682efff7291f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f180b5080e9d8fc17f5327f6c8b298405a849127d637b55dc8a75bfd97c36d6f"
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