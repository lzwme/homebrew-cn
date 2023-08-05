require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.90.0.tgz"
  sha256 "625492bd9e378f57da9f711ae080cecdc49bac07d1a96d01af020484cc0cc1b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "179bdbe54968275774fef3f520ad8fdc255cbd1d32e94ea0796f11887236cd0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "179bdbe54968275774fef3f520ad8fdc255cbd1d32e94ea0796f11887236cd0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "179bdbe54968275774fef3f520ad8fdc255cbd1d32e94ea0796f11887236cd0d"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9d6c81b688333a7596c04f1217cb6d41de0b45777237569be7510955218afe"
    sha256 cellar: :any_skip_relocation, monterey:       "0b9d6c81b688333a7596c04f1217cb6d41de0b45777237569be7510955218afe"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b9d6c81b688333a7596c04f1217cb6d41de0b45777237569be7510955218afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30653448fd7247fecd0d5e8b50035a4db2eba1197fa43df7e5c7d548d9ff1ba4"
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