require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.126.0.tgz"
  sha256 "c1c878fae0e53ce8708e2d4e5cbab5d80a02e7722817b6d9e2aa85a2c2410eea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b0e2540e5f25b09f94f92824cea29c8c947eb8062e65c4f6eeb358b610dcd9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b0e2540e5f25b09f94f92824cea29c8c947eb8062e65c4f6eeb358b610dcd9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b0e2540e5f25b09f94f92824cea29c8c947eb8062e65c4f6eeb358b610dcd9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcd101324a3ab29e8834e5b99f216a813041b9141fa55fc6d9dbb6073866901c"
    sha256 cellar: :any_skip_relocation, ventura:        "dcd101324a3ab29e8834e5b99f216a813041b9141fa55fc6d9dbb6073866901c"
    sha256 cellar: :any_skip_relocation, monterey:       "dcd101324a3ab29e8834e5b99f216a813041b9141fa55fc6d9dbb6073866901c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c9c40941bb394ca7cca9628c74c32e819f0cd9ae5f471c09c51b8d1e8932059"
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