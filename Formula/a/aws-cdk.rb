require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.103.1.tgz"
  sha256 "3f686ef1257c653ffc467e70343b8009d6a212366ad513314a71d665c80ace30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39bcd6d38b31f3f9cbe0bb317edb82f34fb8219a409fcda06b82ec317a1383d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39bcd6d38b31f3f9cbe0bb317edb82f34fb8219a409fcda06b82ec317a1383d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39bcd6d38b31f3f9cbe0bb317edb82f34fb8219a409fcda06b82ec317a1383d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "51e48d19ca27c108bf821c8f509be990c25fd2face2d15c20029abb846f4dc51"
    sha256 cellar: :any_skip_relocation, ventura:        "51e48d19ca27c108bf821c8f509be990c25fd2face2d15c20029abb846f4dc51"
    sha256 cellar: :any_skip_relocation, monterey:       "51e48d19ca27c108bf821c8f509be990c25fd2face2d15c20029abb846f4dc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37be9c76fafadcba79f405bb762db6bf653cfddfc7cee7f26a92fab85abdb6dc"
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