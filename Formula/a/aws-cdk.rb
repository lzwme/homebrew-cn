require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.147.0.tgz"
  sha256 "7aaab3fca88947ef4d4bbc68242d6c223906467c5d607ee0e7bf7c3171b98745"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec8fc9db4cc2079437ef9e841396682a7c1b941efb757bd640625abd3a3c24ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec8fc9db4cc2079437ef9e841396682a7c1b941efb757bd640625abd3a3c24ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec8fc9db4cc2079437ef9e841396682a7c1b941efb757bd640625abd3a3c24ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec8fc9db4cc2079437ef9e841396682a7c1b941efb757bd640625abd3a3c24ad"
    sha256 cellar: :any_skip_relocation, ventura:        "ec8fc9db4cc2079437ef9e841396682a7c1b941efb757bd640625abd3a3c24ad"
    sha256 cellar: :any_skip_relocation, monterey:       "ec8fc9db4cc2079437ef9e841396682a7c1b941efb757bd640625abd3a3c24ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "933788bbc389e380f4e5dab90dd8576cbaad44daafcd71b8475dde49a310f234"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}cdk init app --language=javascript")
      list = shell_output("#{bin}cdk list")
      cdkversion = shell_output("#{bin}cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end