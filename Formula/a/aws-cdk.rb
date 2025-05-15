class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1015.0.tgz"
  sha256 "c16af1c011aabcdc696ef5ce00deb11d351b8c6fd6145639e26eccf58e322669"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4e1ca9f2be81f08be86412791251d12b0b0492cfb3338a2ca61924baefb49e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
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