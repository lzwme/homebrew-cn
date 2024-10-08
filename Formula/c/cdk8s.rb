class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.239.tgz"
  sha256 "34347db4d61ecc2d7de70f531bbf92d83c90fb67ada9aded7a27913b7de3efb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e3558373b3359100e5cabe8d428299d1ac95231918a45846bf7964407f0ca31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e3558373b3359100e5cabe8d428299d1ac95231918a45846bf7964407f0ca31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e3558373b3359100e5cabe8d428299d1ac95231918a45846bf7964407f0ca31"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6220c19b712e4f6512d1efc2b6c3521865c92855d9caf13b7bde7d0dbfdbe4"
    sha256 cellar: :any_skip_relocation, ventura:       "1f6220c19b712e4f6512d1efc2b6c3521865c92855d9caf13b7bde7d0dbfdbe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e3558373b3359100e5cabe8d428299d1ac95231918a45846bf7964407f0ca31"
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