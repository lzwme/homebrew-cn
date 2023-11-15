require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.108.0.tgz"
  sha256 "2db75fb82a8a41154113512b096f48995153f2be1ed0caa37cd23acdc1cf4de0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e9a6c989ceb231b1d91f7ef9033b383561d5f213511a10c3db20600af7b030e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e9a6c989ceb231b1d91f7ef9033b383561d5f213511a10c3db20600af7b030e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e9a6c989ceb231b1d91f7ef9033b383561d5f213511a10c3db20600af7b030e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b635736853e4cb2aa4a593999da1b3ae0e5bd0e0cafbaf9ffd88ebc1739d92db"
    sha256 cellar: :any_skip_relocation, ventura:        "b635736853e4cb2aa4a593999da1b3ae0e5bd0e0cafbaf9ffd88ebc1739d92db"
    sha256 cellar: :any_skip_relocation, monterey:       "b635736853e4cb2aa4a593999da1b3ae0e5bd0e0cafbaf9ffd88ebc1739d92db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a82907e97a56d501791978e29f84d2ba8caf574f6307cd6eecc07b56f006c1ff"
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