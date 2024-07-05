require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.11.tgz"
  sha256 "506991a87e4954efa3c2f0fb02946220f8a1b3d3592d8b1969f26ebab25b9bf9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bd34c5b40c2b0b3ea54eccfbe34a5bae33a98ebe86a646a83b2096ae747f152"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bd34c5b40c2b0b3ea54eccfbe34a5bae33a98ebe86a646a83b2096ae747f152"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd34c5b40c2b0b3ea54eccfbe34a5bae33a98ebe86a646a83b2096ae747f152"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bd34c5b40c2b0b3ea54eccfbe34a5bae33a98ebe86a646a83b2096ae747f152"
    sha256 cellar: :any_skip_relocation, ventura:        "3bd34c5b40c2b0b3ea54eccfbe34a5bae33a98ebe86a646a83b2096ae747f152"
    sha256 cellar: :any_skip_relocation, monterey:       "3bd34c5b40c2b0b3ea54eccfbe34a5bae33a98ebe86a646a83b2096ae747f152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed95d1040311047715bd852a0cc19764f14e5c935d72bf3084c62a816df6c071"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end