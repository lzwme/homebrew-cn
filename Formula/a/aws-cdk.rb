class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1034.0.tgz"
  sha256 "0715bfdd9cce943d89a3e306543e2215bf1947b3c565945ee8cb4c175eaa0117"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bfbac90d12b5f4bbc1604073185d2d17bc2ab8ce28bc3a402f7d3122111a911"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8ff191a589a78949dcab1d78c21f3756416dfcd33134f4dad292e2a495470d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ff191a589a78949dcab1d78c21f3756416dfcd33134f4dad292e2a495470d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e9e60cea592b74d582eafb53d39197d26ed6bc25ba0d1e2416f488a30ebf8ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08cee52dac44e8f8936e3f2c0c36017de94c5ca1ec8e8b94b5ee076f145bddb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08cee52dac44e8f8936e3f2c0c36017de94c5ca1ec8e8b94b5ee076f145bddb9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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