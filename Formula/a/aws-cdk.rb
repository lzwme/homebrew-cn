class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1031.2.tgz"
  sha256 "07c6a1d240ff9d63b328d45d2dba57e970312cef35b7779bc80edc92a3b72aab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4daace941560b46065dead4290a47c29099f8f12f080136d873cb33410203a34"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove empty `node_modules` directory on macOS
    rmdir libexec/"lib/node_modules/aws-cdk/node_modules" if OS.mac?
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