require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.149.0.tgz"
  sha256 "c504cfd69cd60ed2f30349260c0ccbce07f8f38208c4bbbf1e4a082d77c7b4ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3cbd3b42170953cb88dd164904d87c0d93e625bfb51ec012700dab2131fd01d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3cbd3b42170953cb88dd164904d87c0d93e625bfb51ec012700dab2131fd01d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3cbd3b42170953cb88dd164904d87c0d93e625bfb51ec012700dab2131fd01d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3cbd3b42170953cb88dd164904d87c0d93e625bfb51ec012700dab2131fd01d"
    sha256 cellar: :any_skip_relocation, ventura:        "e3cbd3b42170953cb88dd164904d87c0d93e625bfb51ec012700dab2131fd01d"
    sha256 cellar: :any_skip_relocation, monterey:       "e3cbd3b42170953cb88dd164904d87c0d93e625bfb51ec012700dab2131fd01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75c3bad8f79ded4d8d5db28618aa60dc88e157ef35729b72a3a53e4abb38a10f"
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