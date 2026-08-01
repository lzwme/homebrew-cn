class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1134.0.tgz"
  sha256 "c6b93269950afbb2bbbf0d13cb3ae0614584670777e95a6b0eff7d633139ed7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5966729b73dcdd454eb2bb86a53b8b09dfda1750c14985bc55c10ba7e35cae80"
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