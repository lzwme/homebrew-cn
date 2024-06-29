require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.147.2.tgz"
  sha256 "35b711948b87331190a130c8329efcb19ab134e7dcb8d96fd46955da5a548522"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e929c59fff3ac4465c43595ea8428238f7796e685de14415075f650b24d28efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e929c59fff3ac4465c43595ea8428238f7796e685de14415075f650b24d28efc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e929c59fff3ac4465c43595ea8428238f7796e685de14415075f650b24d28efc"
    sha256 cellar: :any_skip_relocation, sonoma:         "e929c59fff3ac4465c43595ea8428238f7796e685de14415075f650b24d28efc"
    sha256 cellar: :any_skip_relocation, ventura:        "e929c59fff3ac4465c43595ea8428238f7796e685de14415075f650b24d28efc"
    sha256 cellar: :any_skip_relocation, monterey:       "e929c59fff3ac4465c43595ea8428238f7796e685de14415075f650b24d28efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099de12f983450fe0478798fc448b7d6ac0a36eae36e89b95304a8d0aae77560"
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