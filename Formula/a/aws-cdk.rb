require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.144.0.tgz"
  sha256 "126ce280b945406a9aff96412e441c58f878f384625def04e16acdc98b2ba2a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46fd37c70e574f0210768f35912c993bfe299ec227f3b186de6a3e49cef72a9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46fd37c70e574f0210768f35912c993bfe299ec227f3b186de6a3e49cef72a9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46fd37c70e574f0210768f35912c993bfe299ec227f3b186de6a3e49cef72a9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "46fd37c70e574f0210768f35912c993bfe299ec227f3b186de6a3e49cef72a9b"
    sha256 cellar: :any_skip_relocation, ventura:        "46fd37c70e574f0210768f35912c993bfe299ec227f3b186de6a3e49cef72a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "46fd37c70e574f0210768f35912c993bfe299ec227f3b186de6a3e49cef72a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d30c9caea5b4ea4155374d1ee113cc4b8eeab930012f198ff7cfda3b986542"
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