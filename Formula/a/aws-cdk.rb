class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1136.0.tgz"
  sha256 "4669cb9be1c57c774ae51ccc58e8958901f8479f45c0ab67517a45ea09cdd501"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9840bdbf4c2d079356dc71ff1fb0614f2103ad075b766b120d409dc4247b065f"
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