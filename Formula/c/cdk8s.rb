class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.206.8.tgz"
  sha256 "9f5e3153db7321ccbcdf1b1c5f3731efed2bff7ce6635dda9e681deb2e04ff54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc4adc4d3c7c3ea3287522e5f73438a31f91ee2ffc2bb5c0ee20aeff2c6cddc9"
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