require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.109.0.tgz"
  sha256 "1ce390fc0f287f9acae9dbc8c6107a73e042986e0c55d4ebefc081cf8392b37b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2575b5c1e006ad6095305a83f950e08a6f174e9807ff0654a320377ccd7b38be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2575b5c1e006ad6095305a83f950e08a6f174e9807ff0654a320377ccd7b38be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2575b5c1e006ad6095305a83f950e08a6f174e9807ff0654a320377ccd7b38be"
    sha256 cellar: :any_skip_relocation, sonoma:         "f349256e9a0d1abfff7573300d14028c737cfd4ae5ee2cd9b6b9a3156691959d"
    sha256 cellar: :any_skip_relocation, ventura:        "f349256e9a0d1abfff7573300d14028c737cfd4ae5ee2cd9b6b9a3156691959d"
    sha256 cellar: :any_skip_relocation, monterey:       "f349256e9a0d1abfff7573300d14028c737cfd4ae5ee2cd9b6b9a3156691959d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c36ffc42ddfba8bb7cbea232c1760cae8f2f7416e9be9f702b6988da35632fd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end