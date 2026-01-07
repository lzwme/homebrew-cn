class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1100.3.tgz"
  sha256 "16cb62414b9815d45e295b1eb924172ac258bba96de756f895748fa1790bfcaa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcb79792633946cd19038096f0e0a1394bf91cf92895c74ae58fd44e8c6cbe49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c774ba1e4aab64828053b23460641667fd563f7ed9f7f92619d2e1d715ba17af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c774ba1e4aab64828053b23460641667fd563f7ed9f7f92619d2e1d715ba17af"
    sha256 cellar: :any_skip_relocation, sonoma:        "da797de6e592cc1845bac582b98b89d42024fad0949dec7f8adca0df5f8fc356"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76e0fb6ff5543799cd1dc89990729a4398de2bb436c57726449444227bc6acc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e0fb6ff5543799cd1dc89990729a4398de2bb436c57726449444227bc6acc4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/aws-cdk/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
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