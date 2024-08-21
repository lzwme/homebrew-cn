class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.12.tgz"
  sha256 "b54a0c9eefcdeaca6cc6f81f06174bd00924a1122d3a4bbe95baf3d74b3f1fb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23e3b8306885bff97f56800661a26ef9a6765cb5a27da09ff61b33d2db0a24c6"
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