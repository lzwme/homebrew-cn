require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.148.1.tgz"
  sha256 "c813ff41d0f8f5a2f8c29c1eef5bf6cf3d85f567baccf071bfed5df5161152a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ff2865b0b666f3e6e1a69795b3730c13a2e5d64f5fcb0a6ca22b7f818de0052"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff2865b0b666f3e6e1a69795b3730c13a2e5d64f5fcb0a6ca22b7f818de0052"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ff2865b0b666f3e6e1a69795b3730c13a2e5d64f5fcb0a6ca22b7f818de0052"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ff2865b0b666f3e6e1a69795b3730c13a2e5d64f5fcb0a6ca22b7f818de0052"
    sha256 cellar: :any_skip_relocation, ventura:        "0ff2865b0b666f3e6e1a69795b3730c13a2e5d64f5fcb0a6ca22b7f818de0052"
    sha256 cellar: :any_skip_relocation, monterey:       "0ff2865b0b666f3e6e1a69795b3730c13a2e5d64f5fcb0a6ca22b7f818de0052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f01ed5fbfdbdcf83e4d9c528bec48db63de79d22827f8b6a24c65354006e9e30"
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