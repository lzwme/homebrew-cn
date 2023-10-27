require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.103.0.tgz"
  sha256 "1699bb96214c42187bf8b2583152ffaa5621219144f2e107b851cc6299839f8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c11d8191b2a049016a972081123db66b94a3ac49046ce9dcdbbecccb15262b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c11d8191b2a049016a972081123db66b94a3ac49046ce9dcdbbecccb15262b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c11d8191b2a049016a972081123db66b94a3ac49046ce9dcdbbecccb15262b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5d15406c3acdf361fd8ded7ca40a9573ff00fd92e5247e6bfef78bfbedd4824"
    sha256 cellar: :any_skip_relocation, ventura:        "a5d15406c3acdf361fd8ded7ca40a9573ff00fd92e5247e6bfef78bfbedd4824"
    sha256 cellar: :any_skip_relocation, monterey:       "a5d15406c3acdf361fd8ded7ca40a9573ff00fd92e5247e6bfef78bfbedd4824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6d23f9cec35bf802335c48417e46f3558ec70cc9f696f42a81dccbc8de7ed0"
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