class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.43.8.tgz"
  sha256 "7ff715b29c38d29d934d5d7a457396d228de1a01ccbfa6a8290db9f2c7c815fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67e30ed1e62c53985031de4dd9d04702e470737c736cf3001fcdf7f820c63118"
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