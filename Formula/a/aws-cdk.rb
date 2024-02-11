require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.127.0.tgz"
  sha256 "113baec32a34a6363adead5649eb43dc10c99a2d7d36d054d88af64539c8a449"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae1f3d6ea2da4287be448dc96d8a66feac924f132017b6e829acf5cab0cc1193"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae1f3d6ea2da4287be448dc96d8a66feac924f132017b6e829acf5cab0cc1193"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae1f3d6ea2da4287be448dc96d8a66feac924f132017b6e829acf5cab0cc1193"
    sha256 cellar: :any_skip_relocation, sonoma:         "10d2d1824681e610900c72108b2a987131eb7e75c5ca2e6ae6f11540504cb992"
    sha256 cellar: :any_skip_relocation, ventura:        "10d2d1824681e610900c72108b2a987131eb7e75c5ca2e6ae6f11540504cb992"
    sha256 cellar: :any_skip_relocation, monterey:       "10d2d1824681e610900c72108b2a987131eb7e75c5ca2e6ae6f11540504cb992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78977ddd3728ca9b7695f2839c257c1503dd7898bdb12631b8e5fc50166d673"
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