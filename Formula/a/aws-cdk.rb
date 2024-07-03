require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.147.3.tgz"
  sha256 "ff5c7a89e0be8dcd59b33ca73645c80b626ae04e2ba8c46b2836ec8e45cf51ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "131630c57873c91916f50d9aabd1082e07f8344a98792a5873dc1e4cf03c552a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "131630c57873c91916f50d9aabd1082e07f8344a98792a5873dc1e4cf03c552a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131630c57873c91916f50d9aabd1082e07f8344a98792a5873dc1e4cf03c552a"
    sha256 cellar: :any_skip_relocation, sonoma:         "131630c57873c91916f50d9aabd1082e07f8344a98792a5873dc1e4cf03c552a"
    sha256 cellar: :any_skip_relocation, ventura:        "131630c57873c91916f50d9aabd1082e07f8344a98792a5873dc1e4cf03c552a"
    sha256 cellar: :any_skip_relocation, monterey:       "131630c57873c91916f50d9aabd1082e07f8344a98792a5873dc1e4cf03c552a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a3c1730e0e896879a363344f5f9b14f4b96919e54cf6352dd92ddea5799fc6"
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