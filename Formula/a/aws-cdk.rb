require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.122.0.tgz"
  sha256 "b05fc2b9bab45b7b0764dfde63b01bc483756b7e1d001d549611b2074e0302e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d8cfec54d95861c98bc6298270b63a05bf8b62c2b4be22556ed06893e8caf5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d8cfec54d95861c98bc6298270b63a05bf8b62c2b4be22556ed06893e8caf5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d8cfec54d95861c98bc6298270b63a05bf8b62c2b4be22556ed06893e8caf5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6911a72e7871164a8065fdec745bc1b7f39398b420a7d4865c29127535e90518"
    sha256 cellar: :any_skip_relocation, ventura:        "6911a72e7871164a8065fdec745bc1b7f39398b420a7d4865c29127535e90518"
    sha256 cellar: :any_skip_relocation, monterey:       "6911a72e7871164a8065fdec745bc1b7f39398b420a7d4865c29127535e90518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "688dc5cc1e7c625d96bae9f4917ea2d24083b8961c523e95e4fbdc9c1c2a46f1"
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