class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1107.0.tgz"
  sha256 "f511fbdf1b24d507fa4b97966ee3ed62521e5bcc43827aeec38ac36a01907213"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8168258fa8dcf11af131b45ada908cc3d42eb48b12ef3544917fd00becdc0c00"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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