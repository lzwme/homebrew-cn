class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.0.tgz"
  sha256 "f6809ec0868ce5055e9cc8ce0d75c5ba4058b36eb675a789fd7c8760dbd114b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb234d1a4815476af7a8e411e4b81a45b58d0c518048dc85b48263bcd9062fb2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end