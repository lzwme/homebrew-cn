require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.129.0.tgz"
  sha256 "d886d13bf2b01ba2345da4d7d6d88e6c06bdf70396c56daa6c68e1b3062cd2f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c7e556085b2ace3c3e0ad12461c83f2850e437772b52e8e316b3317659aa543"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c7e556085b2ace3c3e0ad12461c83f2850e437772b52e8e316b3317659aa543"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c7e556085b2ace3c3e0ad12461c83f2850e437772b52e8e316b3317659aa543"
    sha256 cellar: :any_skip_relocation, sonoma:         "d26fd53c000be5923cbe59d5dc83a3810dc458c6fe1adc89a4d9b2f839174f61"
    sha256 cellar: :any_skip_relocation, ventura:        "d26fd53c000be5923cbe59d5dc83a3810dc458c6fe1adc89a4d9b2f839174f61"
    sha256 cellar: :any_skip_relocation, monterey:       "d26fd53c000be5923cbe59d5dc83a3810dc458c6fe1adc89a4d9b2f839174f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b740c08d4374f53ea720cd34dd8de52f517b7082fe453977fc52e4d60d0b20"
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