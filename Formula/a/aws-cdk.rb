require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.101.0.tgz"
  sha256 "6237c50a7916654338e04c4f12dfdceaf1d4cbde327f4358af932ab693be2d55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da89b40ff363418974cffc1e95d7087a9fcc7c5708ffcc4a2725418befe215ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da89b40ff363418974cffc1e95d7087a9fcc7c5708ffcc4a2725418befe215ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da89b40ff363418974cffc1e95d7087a9fcc7c5708ffcc4a2725418befe215ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "703d71d5adc3f98bee61c7d50ec91593ec367793dd10f24d8a03669e05047981"
    sha256 cellar: :any_skip_relocation, ventura:        "703d71d5adc3f98bee61c7d50ec91593ec367793dd10f24d8a03669e05047981"
    sha256 cellar: :any_skip_relocation, monterey:       "703d71d5adc3f98bee61c7d50ec91593ec367793dd10f24d8a03669e05047981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65078281e183b0d79067bbd223874d78c86bdbbc20b4b4e60b2452d8707ccad5"
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