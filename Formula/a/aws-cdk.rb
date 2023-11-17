require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.110.0.tgz"
  sha256 "5c8223f445af23699a5f46c040352a599de7228cda94c9a26c9cab3522e15a0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ad1d1e4eee46178c690eed44b890407499849c6dcb0bea13f3627a3128b9dd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ad1d1e4eee46178c690eed44b890407499849c6dcb0bea13f3627a3128b9dd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ad1d1e4eee46178c690eed44b890407499849c6dcb0bea13f3627a3128b9dd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce0da922761ab0f3ff97a8e5957eb9eb25dbbf9c3223c7a633c78fb5ba5260c2"
    sha256 cellar: :any_skip_relocation, ventura:        "ce0da922761ab0f3ff97a8e5957eb9eb25dbbf9c3223c7a633c78fb5ba5260c2"
    sha256 cellar: :any_skip_relocation, monterey:       "ce0da922761ab0f3ff97a8e5957eb9eb25dbbf9c3223c7a633c78fb5ba5260c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd501db075fe7838b5e91cc19f9f50ca3860d04762a51a257e72065be991488"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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