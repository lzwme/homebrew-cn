class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.155.0.tgz"
  sha256 "4be6e81f7c45cebe1ba232910cfdaf2dd67a670a05553e39fad2c167166950e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df6cd8d969f67f09d98541ca6d56eedee912ff777ba70c18bbd6b8815abeb73e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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