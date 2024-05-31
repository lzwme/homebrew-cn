require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.143.1.tgz"
  sha256 "9d7c828b5f24f5f3e706ca2e0e81b6fa387dd169b557b5d4df535a67e1143705"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d39a9d5d35c75d20a410e2bb008efbc00c378d3e60303f09d7616695d7ed32dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d39a9d5d35c75d20a410e2bb008efbc00c378d3e60303f09d7616695d7ed32dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d39a9d5d35c75d20a410e2bb008efbc00c378d3e60303f09d7616695d7ed32dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "d39a9d5d35c75d20a410e2bb008efbc00c378d3e60303f09d7616695d7ed32dd"
    sha256 cellar: :any_skip_relocation, ventura:        "d39a9d5d35c75d20a410e2bb008efbc00c378d3e60303f09d7616695d7ed32dd"
    sha256 cellar: :any_skip_relocation, monterey:       "d39a9d5d35c75d20a410e2bb008efbc00c378d3e60303f09d7616695d7ed32dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da43016bf0c9f8156417553584f9fa05b7611b3707e27b76b68e0fec3d3e720e"
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