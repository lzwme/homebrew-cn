class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1100.0.tgz"
  sha256 "e7f2cbf148381afe5458320774b83124a7c7a6094dfdcc68d9f8968c6334b7b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bda9596fef4b3b0a545f966505c5ca2ac876b94d97593912d002417fe9bdc05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c45993776ee874af6979b8749da2324ff8e404b289c999770e6711ed41ddc278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45993776ee874af6979b8749da2324ff8e404b289c999770e6711ed41ddc278"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4bb583340a8172d966f99880ba2c48cf878a5a23b89e1d6077cd3e30549c4d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6079d1f9f03970721a5f8f2710233bd84aabd41bfcc9735b7aaac9b8ef32d8b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6079d1f9f03970721a5f8f2710233bd84aabd41bfcc9735b7aaac9b8ef32d8b6"
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