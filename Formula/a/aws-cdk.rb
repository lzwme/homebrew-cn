require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.148.0.tgz"
  sha256 "7a7818a7249c3f4dfc136e2b53e85ade06f7b8423896fba861f0fe05c5762b1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ab7a1c0c60a59f1b752a30d78803ba1aad239d9b54bcec72cadc3f7fe9b0ca6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ab7a1c0c60a59f1b752a30d78803ba1aad239d9b54bcec72cadc3f7fe9b0ca6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ab7a1c0c60a59f1b752a30d78803ba1aad239d9b54bcec72cadc3f7fe9b0ca6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ab7a1c0c60a59f1b752a30d78803ba1aad239d9b54bcec72cadc3f7fe9b0ca6"
    sha256 cellar: :any_skip_relocation, ventura:        "4ab7a1c0c60a59f1b752a30d78803ba1aad239d9b54bcec72cadc3f7fe9b0ca6"
    sha256 cellar: :any_skip_relocation, monterey:       "4ab7a1c0c60a59f1b752a30d78803ba1aad239d9b54bcec72cadc3f7fe9b0ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83a64867075292d625a4e57ee80e259247e70f7ddcace02781de0f7e51d73d54"
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