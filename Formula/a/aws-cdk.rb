require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.142.1.tgz"
  sha256 "ab877ce91c0bb72ae90087cf32bba13ea00fccc8f704c4bb054230b5d465ab12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7b78d0f0c7a591c94c316342c8a91efbe55c3a8d470a71f96d613e894877cf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dbd80892ada25380395688415bb031591099289fb4c7c1a80cb433db48a9b29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c197430c84c47b3e51ce312bdde468f19b946f8c5af5007f3cdb832a528fd9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8629ebdf21cc9f54e7f0efacece346d80959f2bd83527a251ebc628d8ee223a"
    sha256 cellar: :any_skip_relocation, ventura:        "574bc2230e92cd50eb9dd75cc8af8a1f430f3d684d06059dfc0075dab2cfc331"
    sha256 cellar: :any_skip_relocation, monterey:       "03492258030174c520fa1e56c9dda6f1dec675b9f39cf0fbf4f16ff7ed3f564d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a64a0776ff43d34d5c02bddf4bff9e979e7d22400c1e54480c20050b488b176c"
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