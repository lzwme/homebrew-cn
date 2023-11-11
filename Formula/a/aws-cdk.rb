require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.106.0.tgz"
  sha256 "530da6c387b9fa11364734a706c26b70651fb08ae79d1012dd2de08252d404b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "062cc1ff7b98df590681b1aedebf7d89112e98862da857bd8076e7cf46425d6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "062cc1ff7b98df590681b1aedebf7d89112e98862da857bd8076e7cf46425d6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "062cc1ff7b98df590681b1aedebf7d89112e98862da857bd8076e7cf46425d6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6ed9a013e3dbe64cdb4dfcd2265af1e3a0684d7d8fa145ff3752295c2fa4e15"
    sha256 cellar: :any_skip_relocation, ventura:        "f6ed9a013e3dbe64cdb4dfcd2265af1e3a0684d7d8fa145ff3752295c2fa4e15"
    sha256 cellar: :any_skip_relocation, monterey:       "f6ed9a013e3dbe64cdb4dfcd2265af1e3a0684d7d8fa145ff3752295c2fa4e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dffb693347c3651d1a6440c036bb3aca8402b8db7e7564503e7e9c66e7146c72"
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