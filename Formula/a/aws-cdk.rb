class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1100.1.tgz"
  sha256 "e002f9bd973692a6a819740d547a2a91f9d8ceeca0927b5bfe9f37b06e119d9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "577bbe4a038a67f165c1f06b5c8edbc0e139f49d84316abb4ba64b9f57fdb57f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e065b0cecb942b8d2ba5c06a5960b9bcd67038ed2cf84601c195c0d20bd946e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e065b0cecb942b8d2ba5c06a5960b9bcd67038ed2cf84601c195c0d20bd946e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "de4f4132ce63b80f89e874616a5aeb8afd3cf98f3da7a2a942800686b5342e2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66475e210ab9caa81452f43c2971b90b88f798499294d7a9d3452d6bc3f4b9ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66475e210ab9caa81452f43c2971b90b88f798499294d7a9d3452d6bc3f4b9ab"
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