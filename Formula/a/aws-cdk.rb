require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.105.0.tgz"
  sha256 "c7e4e344d50c5a48968227503fb7ba0454c5c69abcc6a9d19574ccd2ce78b0a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "905e582f9f21e298bfe408e9ccdbc26280989ecd27ac5734c18fee271d61949f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "905e582f9f21e298bfe408e9ccdbc26280989ecd27ac5734c18fee271d61949f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "905e582f9f21e298bfe408e9ccdbc26280989ecd27ac5734c18fee271d61949f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bae7e6f67d9f82170e9e2009b38be11cff640cc9b4c33a33bbcd5d8aaf8ca58a"
    sha256 cellar: :any_skip_relocation, ventura:        "bae7e6f67d9f82170e9e2009b38be11cff640cc9b4c33a33bbcd5d8aaf8ca58a"
    sha256 cellar: :any_skip_relocation, monterey:       "bae7e6f67d9f82170e9e2009b38be11cff640cc9b4c33a33bbcd5d8aaf8ca58a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba7922c0052ae7b295ab827e71a85818987cd872242c536a4fcdaa111eb5d9ba"
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