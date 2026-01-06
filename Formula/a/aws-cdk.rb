class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1100.2.tgz"
  sha256 "380bd755be3b8942d75728cdfcaccbd8d45ee03fbefd108af0f1071ea7ff3a8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b8bba08936f4b7db4c5a337c42fa5cf1d9195ca031d9ccda39e610fe37ce5a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d0762a370d42f2879f3e27d4c47046afe97635b77dc9acdb8b0ca768a2c91c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d0762a370d42f2879f3e27d4c47046afe97635b77dc9acdb8b0ca768a2c91c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d42105d764e89ac124b6fb37d38fc63e68222b7c10155579a8a5ee08b7c6fa20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d86f47bb9e36d292626c3072cf86fbf85b5e603dd99ade2fc90643b35958f768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d86f47bb9e36d292626c3072cf86fbf85b5e603dd99ade2fc90643b35958f768"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/aws-cdk/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end