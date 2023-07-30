require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.89.0.tgz"
  sha256 "09a7549b9a1a25b33894f4c41a59bddebc6ae39bd607798ece9f24ab4940e461"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9df12ec9805d4874ea95a48109a563eb5516f9e7a2bc16deec74ee614c51366c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9df12ec9805d4874ea95a48109a563eb5516f9e7a2bc16deec74ee614c51366c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9df12ec9805d4874ea95a48109a563eb5516f9e7a2bc16deec74ee614c51366c"
    sha256 cellar: :any_skip_relocation, ventura:        "80c3815cecc4daa2cb1a11364b92c56177093aa5f7694a3b3660bc58f3cd0804"
    sha256 cellar: :any_skip_relocation, monterey:       "80c3815cecc4daa2cb1a11364b92c56177093aa5f7694a3b3660bc58f3cd0804"
    sha256 cellar: :any_skip_relocation, big_sur:        "80c3815cecc4daa2cb1a11364b92c56177093aa5f7694a3b3660bc58f3cd0804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ef456a7ff8884c947bf0e3a956c51fdb156eaf57924a4de50210d96a0e4be7e"
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