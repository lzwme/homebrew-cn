require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.88.0.tgz"
  sha256 "fdd4e15f64759db43e2d963a485ec224b598baa1380ac1f786065bf4d42ec94f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57dfe3b6d40a25a77edabb3eb1f079b9628cf61b88780f94306bebc5099f1549"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57dfe3b6d40a25a77edabb3eb1f079b9628cf61b88780f94306bebc5099f1549"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57dfe3b6d40a25a77edabb3eb1f079b9628cf61b88780f94306bebc5099f1549"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd52fa9f1809b8a3a250fd54184ca87b60838ba09e7020ec87bae783b13f9bb"
    sha256 cellar: :any_skip_relocation, monterey:       "7fd52fa9f1809b8a3a250fd54184ca87b60838ba09e7020ec87bae783b13f9bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fd52fa9f1809b8a3a250fd54184ca87b60838ba09e7020ec87bae783b13f9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5fb8b476db510c2fbd8a25f283191c2ec032142d0f19efee9f3761e2d561a70"
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