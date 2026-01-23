class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1102.0.tgz"
  sha256 "f656e5d93a93b04e6c29ed7504325895191d05e7c41f158396260a42ad1ee6e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e4e5bed57b3980923a4fa286bed65214297496da6728a7e229ad65eee93c9bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7ae5f14100fe52b2f953dcbed52c883272e6a8c2f8dd2e60123c25ca8362b38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7ae5f14100fe52b2f953dcbed52c883272e6a8c2f8dd2e60123c25ca8362b38"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f2e89b3932b3bec2ccafecc5cd581b7c3d215e14346ca0ba87684615b59ccb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9157862a2492f20a49fdb1cb7ad8975307524cc78eb495afd3f728ec5c77767a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9157862a2492f20a49fdb1cb7ad8975307524cc78eb495afd3f728ec5c77767a"
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