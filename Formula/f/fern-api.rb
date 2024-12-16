class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.3.tgz"
  sha256 "02c7d828eb54319c9547ab0f0f9105e556043a7da89b7e8b6d9c2a0eb5931c82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0999863136128c295bc8a1847d852f30dfbbffa6e81354f90fde2a2bd580adf"
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