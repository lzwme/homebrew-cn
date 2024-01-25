require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.123.0.tgz"
  sha256 "4318fc01505dbb297b7ec06da0a6df2460ae4d529d436b2b3a0ce44369cce3aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6df3af845814f8ef4166a58570c41b176ed64c849d0c0428bc10331ae66cd8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6df3af845814f8ef4166a58570c41b176ed64c849d0c0428bc10331ae66cd8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6df3af845814f8ef4166a58570c41b176ed64c849d0c0428bc10331ae66cd8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fc393a51d85426be5e5a8dc60c4a26133d06afa757428339c466b2807872580"
    sha256 cellar: :any_skip_relocation, ventura:        "1fc393a51d85426be5e5a8dc60c4a26133d06afa757428339c466b2807872580"
    sha256 cellar: :any_skip_relocation, monterey:       "1fc393a51d85426be5e5a8dc60c4a26133d06afa757428339c466b2807872580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e69bb76f226a807af20cd245ab519e6435674dce3564b66b2603cf89e6d5750"
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