require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.143.0.tgz"
  sha256 "72a3649bd824bda41fd1167985932f680e28fe0b2181819b0fbeeecf37568f3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d552f29c6f745ea41dd944f9c7fe21026c970fb149b9a12d2ef1bc8580e2c232"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05097c7e557f9fed7cf75af27ebcf90ed95b5162f2f0693819770685591836ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cbb8e60376fa5a035efd2a350e4ae877c5c52b5fe8aaff977feb1ff4f9ddf3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "040bf8db5cf48bb5268f9d0e5ca7285f93daa6304326ece1117609a063bd2d0f"
    sha256 cellar: :any_skip_relocation, ventura:        "bcaf25348dd9982977f8645e826159a2350e995f967c3854a22a349e636ed6ed"
    sha256 cellar: :any_skip_relocation, monterey:       "95bab505cfa60fe4a28e1bf003752349eadabb14f7a283594658a585fe11f14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34951c478a5a24fe00edba79586a97c85e43310682c2f222bcb8205b28a687dc"
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