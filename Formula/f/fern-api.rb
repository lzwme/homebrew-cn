class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.45.0.tgz"
  sha256 "dc0b5ed3e86900d293be8c3ad62b6c295ca4009883c444fa6e6b8752cc3856c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d270530c15c1511c720241f2e4ce831955df4435553ff041ac974e257cf0a817"
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