class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.162.0.tgz"
  sha256 "b20c983cfa8779d7e9a41800ae3eac3462f7579a3bb4a6aa7f4ca9f6376a556b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c1814f1c0977bfe002fe0cb8ecf04179363adde84f9582090a0c62315e94e4d"
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