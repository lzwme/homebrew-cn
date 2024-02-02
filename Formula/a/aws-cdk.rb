require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.125.0.tgz"
  sha256 "1128ff9feac8e39e2c372cb2c1b91167c2ba9a3b7ded0e07d0ecec5891668355"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebec33bcc0af3f7231d780e8c596cee4e46515615a23e5df2125afeda0b966cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebec33bcc0af3f7231d780e8c596cee4e46515615a23e5df2125afeda0b966cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebec33bcc0af3f7231d780e8c596cee4e46515615a23e5df2125afeda0b966cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e5cb08cd0d9ed0895c0201786e34fee690d600119c9020cabd686107d0a0177"
    sha256 cellar: :any_skip_relocation, ventura:        "4e5cb08cd0d9ed0895c0201786e34fee690d600119c9020cabd686107d0a0177"
    sha256 cellar: :any_skip_relocation, monterey:       "4e5cb08cd0d9ed0895c0201786e34fee690d600119c9020cabd686107d0a0177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab53ce8a83888047c98c0fe7e9a5a3ffa5a3fc388c82e01822c4861765d22786"
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