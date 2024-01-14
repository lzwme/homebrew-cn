require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.121.0.tgz"
  sha256 "c0bea8966ca6196eac3185507955e8617fa180ebc65e1e8d1dbe3325b52f6da0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ae09a8c7b9ca1800f6385729f4952558233651e6436e9e5afcdcdd92cd66c93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ae09a8c7b9ca1800f6385729f4952558233651e6436e9e5afcdcdd92cd66c93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ae09a8c7b9ca1800f6385729f4952558233651e6436e9e5afcdcdd92cd66c93"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1cf1cfe505784bb6921ec0efbc2729e4195c3693386198511160b9bc032a69a"
    sha256 cellar: :any_skip_relocation, ventura:        "c1cf1cfe505784bb6921ec0efbc2729e4195c3693386198511160b9bc032a69a"
    sha256 cellar: :any_skip_relocation, monterey:       "c1cf1cfe505784bb6921ec0efbc2729e4195c3693386198511160b9bc032a69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7a724b52c9747f382e70a2449273f8df2fc3433d3fe1695808152cabb8ce1b6"
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