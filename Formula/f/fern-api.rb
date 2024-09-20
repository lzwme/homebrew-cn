class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.42.11.tgz"
  sha256 "2c783cb5c6f77ea1c23ffdd97ca9b7070d3fa3b6fb9f7559f84edfdb4789b3b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28f6751f84980f5a179f992e59587773f9da3ee2d6d3123d7797883a3b2b563a"
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