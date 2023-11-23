require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.110.1.tgz"
  sha256 "292fef0dec48556cacb311927124e617f645e79da1b03b53bfccaf6540bc5926"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23321d436a015180baa7ae22cb7d2bfda7840833f8aaf930ea099167d58899bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23321d436a015180baa7ae22cb7d2bfda7840833f8aaf930ea099167d58899bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23321d436a015180baa7ae22cb7d2bfda7840833f8aaf930ea099167d58899bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "07448a78feab3d289d433c285e0cb0377c396d93c2d0c4d6c7f461ed36d46bf5"
    sha256 cellar: :any_skip_relocation, ventura:        "07448a78feab3d289d433c285e0cb0377c396d93c2d0c4d6c7f461ed36d46bf5"
    sha256 cellar: :any_skip_relocation, monterey:       "07448a78feab3d289d433c285e0cb0377c396d93c2d0c4d6c7f461ed36d46bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfdaa394b07d89fb39aaff17dfb0bda112673d55f90db8d27e4eeca1f56466a6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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