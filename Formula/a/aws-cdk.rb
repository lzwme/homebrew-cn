require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.111.0.tgz"
  sha256 "e7551ca0f8c9cc6805e1c4f24da3e4a294df8be3ec10ce965ccf39c9b6111536"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "729293bbd17fe9d35ae2ffb8e7efda7833e92b3146a9d27f08427cfb31eb191c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "729293bbd17fe9d35ae2ffb8e7efda7833e92b3146a9d27f08427cfb31eb191c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "729293bbd17fe9d35ae2ffb8e7efda7833e92b3146a9d27f08427cfb31eb191c"
    sha256 cellar: :any_skip_relocation, sonoma:         "027df04d645a3b197186e9ac6f219f32588c588176de926f14b5da233fb90c99"
    sha256 cellar: :any_skip_relocation, ventura:        "027df04d645a3b197186e9ac6f219f32588c588176de926f14b5da233fb90c99"
    sha256 cellar: :any_skip_relocation, monterey:       "027df04d645a3b197186e9ac6f219f32588c588176de926f14b5da233fb90c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d419e79e1ff1887a0df8bd898bc987e8a602bc163b7debb0506552b67289eefa"
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