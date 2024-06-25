require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.147.1.tgz"
  sha256 "c75c0568ff7e8b2095d830a03e1626d0f2ca77eb97649dc2ee58e514f948a09a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b87262583585361ff1ee709d0dc5d8fd61c2798cfbf62cd537e8885f893eb87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b87262583585361ff1ee709d0dc5d8fd61c2798cfbf62cd537e8885f893eb87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b87262583585361ff1ee709d0dc5d8fd61c2798cfbf62cd537e8885f893eb87"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b87262583585361ff1ee709d0dc5d8fd61c2798cfbf62cd537e8885f893eb87"
    sha256 cellar: :any_skip_relocation, ventura:        "9b87262583585361ff1ee709d0dc5d8fd61c2798cfbf62cd537e8885f893eb87"
    sha256 cellar: :any_skip_relocation, monterey:       "9b87262583585361ff1ee709d0dc5d8fd61c2798cfbf62cd537e8885f893eb87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "278bb68d49db6d9e3a68c9a1adadd87935bf52d9997fb9426b55b23d96b74f2b"
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